#!/usr/bin/env python3
"""
instapaper-export.py

Fetches all bookmarks from an Instapaper account (Unread, Starred, Archive)
and saves them as JSON: [{title, link, tags}]

Requirements: Python 3.9+
  pip install requests python-dotenv

Usage:
  python instapaper-export.py

Status/progress → stderr. Output → instapaper-bookmarks.json
Get consumer key/secret at: https://www.instapaper.com/developers/applications
"""

from __future__ import annotations

import base64
import hashlib
import hmac
import json
import logging
import os
import secrets
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import parse_qs, quote

import requests
from dotenv import load_dotenv

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Config:
    consumer_key: str
    consumer_secret: str
    username: str
    password: str = ""

load_dotenv()

CONFIG = Config(
    consumer_key=os.environ.get("INSTAPAPER_CONSUMER_KEY", ""),
    consumer_secret=os.environ.get("INSTAPAPER_CONSUMER_SECRET", ""),
    username=os.environ.get("INSTAPAPER_USERNAME", ""),
    password=os.environ.get("INSTAPAPER_PASSWORD", ""),
)

BASE_URL = "https://www.instapaper.com/api/1"
FOLDERS = ["unread"]
LIMIT = 500  # maximum allowed by the API
OUTPUT_PATH = Path("instapaper-bookmarks.json")

logging.basicConfig(stream=sys.stderr, level=logging.INFO, format="%(message)s")
log = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# OAuth 1.0a helpers
# ---------------------------------------------------------------------------

def _pct(value: str) -> str:
    """RFC 3986 percent-encoding. quote(safe='') encodes !, ', (, ), * as required by OAuth."""
    return quote(str(value), safe="")


def _build_signature(
    method: str,
    url: str,
    params: dict[str, str],
    consumer_secret: str,
    token_secret: str = "",
) -> str:
    normalized = "&".join(
        f"{_pct(k)}={_pct(v)}" for k, v in sorted(params.items())
    )
    base = "&".join([method.upper(), _pct(url), _pct(normalized)])
    key = f"{_pct(consumer_secret)}&{_pct(token_secret)}"
    digest = hmac.new(key.encode(), base.encode(), hashlib.sha1).digest()
    return base64.b64encode(digest).decode()


def _auth_header(oauth_params: dict[str, str]) -> str:
    parts = ", ".join(f'{k}="{_pct(v)}"' for k, v in oauth_params.items())
    return f"OAuth {parts}"


def _signed_post(
    url: str,
    body: dict[str, str] | None = None,
    token: str = "",
    token_secret: str = "",
) -> requests.Response:
    body = body or {}
    oauth: dict[str, str] = {
        "oauth_consumer_key": CONFIG.consumer_key,
        "oauth_nonce": secrets.token_hex(16),
        "oauth_signature_method": "HMAC-SHA1",
        "oauth_timestamp": str(int(time.time())),
        "oauth_version": "1.0",
        **({"oauth_token": token} if token else {}),
    }
    oauth["oauth_signature"] = _build_signature(
        "POST", url, {**oauth, **body}, CONFIG.consumer_secret, token_secret
    )
    return requests.post(
        url,
        headers={
            "Authorization": _auth_header(oauth),
            "Content-Type": "application/x-www-form-urlencoded",
        },
        data=body,
    )

# ---------------------------------------------------------------------------
# Authentication — xAuth flow
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class OAuthToken:
    token: str
    secret: str


def authenticate() -> OAuthToken:
    resp = _signed_post(
        f"{BASE_URL}/oauth/access_token",
        {
            "x_auth_username": CONFIG.username,
            "x_auth_password": CONFIG.password,
            "x_auth_mode": "client_auth",
        },
    )
    if not resp.ok:
        raise RuntimeError(f"Authentication failed (HTTP {resp.status_code}): {resp.text}")

    parsed = parse_qs(resp.text)
    try:
        return OAuthToken(
            token=parsed["oauth_token"][0],
            secret=parsed["oauth_token_secret"][0],
        )
    except (KeyError, IndexError):
        raise RuntimeError(f"Unexpected auth response — missing token fields: {resp.text}")

# ---------------------------------------------------------------------------
# Bookmark fetching with pagination
# ---------------------------------------------------------------------------

def _fetch_folder(auth: OAuthToken, folder_id: str) -> list[dict]:
    """Fetches all bookmarks from a folder. Uses `have` param to paginate past 500-item limit."""
    url = f"{BASE_URL}/bookmarks/list"
    collected: list[dict] = []

    while True:
        body: dict[str, str] = {"folder_id": folder_id, "limit": str(LIMIT)}
        if collected:
            body["have"] = ",".join(str(b["bookmark_id"]) for b in collected)

        resp = _signed_post(url, body, auth.token, auth.secret)
        if not resp.ok:
            raise RuntimeError(
                f'Failed to fetch folder "{folder_id}" (HTTP {resp.status_code}): {resp.text}'
            )

        data = resp.json()
        # Standard format: [{type: 'meta'}, {type: 'bookmark'}, ...]
        # Non-standard format: {user: ..., bookmarks: [...]}
        bookmarks = (
            [item for item in data if item.get("type") == "bookmark"]
            if isinstance(data, list)
            else data.get("bookmarks", [])
        )

        if not bookmarks:
            break
        collected.extend(bookmarks)
        if len(bookmarks) < LIMIT:
            break

        log.info("  %s: fetched %d so far, checking for more...", folder_id, len(collected))

    return collected


def _format(b: dict) -> dict:
    """Tags from the API are [{id, name}]; keep only names."""
    return {
        "title": b.get("title", ""),
        "link": b.get("url", ""),
        "tags": [t["name"] for t in b.get("tags", [])],
    }

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    missing = [k for k in ("consumer_key", "consumer_secret", "username") if not getattr(CONFIG, k)]
    if missing:
        env_names = {
            "consumer_key": "INSTAPAPER_CONSUMER_KEY",
            "consumer_secret": "INSTAPAPER_CONSUMER_SECRET",
            "username": "INSTAPAPER_USERNAME",
        }
        log.error("Missing required config:\n  %s", "\n  ".join(env_names[k] for k in missing))
        sys.exit(1)

    log.info("Authenticating with Instapaper...")
    auth = authenticate()
    log.info("Authenticated.\n")

    all_bookmarks: list[dict] = []
    seen: set = set()

    for folder in FOLDERS:
        log.info('Fetching "%s"...', folder)
        bookmarks = _fetch_folder(auth, folder)
        new = [b for b in bookmarks if b["bookmark_id"] not in seen]
        seen.update(b["bookmark_id"] for b in new)
        all_bookmarks.extend(new)
        log.info("  → %d items added (%d duplicates skipped)", len(new), len(bookmarks) - len(new))

    log.info("\nTotal: %d unique bookmarks\n", len(all_bookmarks))

    OUTPUT_PATH.write_text(
        json.dumps([_format(b) for b in all_bookmarks], indent=2) + "\n",
        encoding="utf-8",
    )
    log.info("Saved to %s", OUTPUT_PATH)


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        log.error("\nFatal error: %s", exc)
        sys.exit(1)
