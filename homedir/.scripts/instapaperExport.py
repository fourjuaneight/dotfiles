#!/usr/bin/env python3
"""
instapaper_export.py
Pulls all bookmarks from Instapaper via the Full API and saves them as a
Pocket-format CSV ready for import into Linkwarden.

Requirements:
    pip install requests python-dotenv

Usage:
    # Recommended: place a .env file next to this script:
    #   INSTAPAPER_CONSUMER_KEY=your_consumer_key
    #   INSTAPAPER_CONSUMER_SECRET=your_consumer_secret
    #   INSTAPAPER_USERNAME=your_email
    #   INSTAPAPER_PASSWORD=your_password     # omit if you have no password

    python3 instapaperExport.py [output.csv]

    # CLI flags override .env values:
    python3 instapaperExport.py \
        --consumer-key KEY \
        --consumer-secret SECRET \
        --username EMAIL \
        [--password PASSWORD] \
        [output.csv]

Output columns: title,url,time_added,cursor,tags,status
    - status is "unread" for unread items, "read" for archive, "starred" adds a tag
    - tags are pipe-separated; starred items get a "starred" tag appended
    - time_added is the Unix timestamp from Instapaper

Notes:
    - Fetches unread, starred, and archive folders
    - Paginates automatically (Instapaper max 500 per request)
    - Requires an OAuth consumer key — apply at:
      https://www.instapaper.com/developers/applications/create
"""
from __future__ import annotations

import argparse
import base64
import csv
import hashlib
import hmac
import os
from pathlib import Path
import time
import urllib.parse
import uuid

import requests
try:
    from dotenv import load_dotenv
except ImportError:
    load_dotenv = None

BASE_URL = "https://www.instapaper.com"
TOKEN_URL = f"{BASE_URL}/api/1/oauth/access_token"
BOOKMARKS_URL = f"{BASE_URL}/api/1/bookmarks/list"


# ---------------------------------------------------------------------------
# OAuth 1.0a signing (xAuth)
# ---------------------------------------------------------------------------

def _percent_encode(s: str) -> str:
    return urllib.parse.quote(str(s), safe="")


def _build_auth_header(
    method: str,
    url: str,
    consumer_key: str,
    consumer_secret: str,
    oauth_token: str = "",
    oauth_token_secret: str = "",
    extra_params: dict | None = None,
) -> str:
    """Build the OAuth 1.0a Authorization header value."""
    oauth_params = {
        "oauth_consumer_key": consumer_key,
        "oauth_nonce": uuid.uuid4().hex,
        "oauth_signature_method": "HMAC-SHA1",
        "oauth_timestamp": str(int(time.time())),
        "oauth_version": "1.0",
    }
    if oauth_token:
        oauth_params["oauth_token"] = oauth_token

    # All params go into the signature base (oauth + body/extra)
    all_params = {**oauth_params, **(extra_params or {})}
    sorted_params = sorted(
        (_percent_encode(k), _percent_encode(v)) for k, v in all_params.items()
    )
    param_string = "&".join(f"{k}={v}" for k, v in sorted_params)

    signature_base = "&".join([
        method.upper(),
        _percent_encode(url),
        _percent_encode(param_string),
    ])

    signing_key = f"{_percent_encode(consumer_secret)}&{_percent_encode(oauth_token_secret)}"
    hashed = hmac.new(signing_key.encode(), signature_base.encode(), hashlib.sha1)
    signature = base64.b64encode(hashed.digest()).decode()

    oauth_params["oauth_signature"] = signature
    header_parts = ", ".join(
        f'{_percent_encode(k)}="{_percent_encode(v)}"'
        for k, v in sorted(oauth_params.items())
    )
    return f"OAuth {header_parts}"


# ---------------------------------------------------------------------------
# Instapaper API calls
# ---------------------------------------------------------------------------

def get_access_token(
    consumer_key: str,
    consumer_secret: str,
    username: str,
    password: str,
) -> tuple[str, str]:
    """Exchange xAuth credentials for an OAuth access token."""
    body = {
        "x_auth_username": username,
        "x_auth_password": password,
        "x_auth_mode": "client_auth",
    }
    auth_header = _build_auth_header(
        "POST", TOKEN_URL, consumer_key, consumer_secret, extra_params=body
    )
    resp = requests.post(
        TOKEN_URL,
        data=body,
        headers={"Authorization": auth_header},
        timeout=15,
    )
    resp.raise_for_status()

    parsed = dict(urllib.parse.parse_qsl(resp.text.strip()))
    token = parsed.get("oauth_token", "")
    secret = parsed.get("oauth_token_secret", "")
    if not token:
        raise ValueError(f"Token request failed: {resp.text}")
    return token, secret


def fetch_folder(
    consumer_key: str,
    consumer_secret: str,
    token: str,
    token_secret: str,
    folder_id: str,
) -> list[dict]:
    """Fetch all bookmarks from a folder, paginating via the 'have' param."""
    all_bookmarks: list[dict] = []
    have_ids: set[str] = set()

    while True:
        body: dict = {"folder_id": folder_id, "limit": "500"}
        if have_ids:
            body["have"] = ",".join(have_ids)

        auth_header = _build_auth_header(
            "POST",
            BOOKMARKS_URL,
            consumer_key,
            consumer_secret,
            oauth_token=token,
            oauth_token_secret=token_secret,
            extra_params=body,
        )
        resp = requests.post(
            BOOKMARKS_URL,
            data=body,
            headers={"Authorization": auth_header},
            timeout=30,
        )
        resp.raise_for_status()
        data = resp.json()  # list of typed objects: bookmark, user, meta

        batch = [item for item in data if item.get("type") == "bookmark"]
        if not batch:
            break

        all_bookmarks.extend(batch)
        have_ids.update(
            str(b["bookmark_id"]) for b in batch if b.get("bookmark_id") is not None
        )

        # If we got fewer than 500, we've reached the end
        if len(batch) < 500:
            break

        print(f"  Fetched {len(all_bookmarks)} from '{folder_id}' so far, paginating…")
        time.sleep(0.5)

    return all_bookmarks


# ---------------------------------------------------------------------------
# Conversion helpers
# ---------------------------------------------------------------------------

def bookmark_to_row(bookmark: dict, status: str, extra_tag: str = "") -> dict:
    """Convert an Instapaper bookmark dict to a Pocket CSV row dict."""
    title = (bookmark.get("title") or "").strip() or bookmark.get("url", "")
    url = bookmark.get("url", "").strip()
    time_added = bookmark.get("time", 0)

    raw_tags = bookmark.get("tags") or []
    tag_names = [t["name"] for t in raw_tags if isinstance(t, dict) and "name" in t]
    if extra_tag:
        tag_names.append(extra_tag)
    tags = "|".join(tag_names)

    return {
        "title": title,
        "url": url,
        "time_added": time_added,
        "cursor": time_added,
        "tags": tags,
        "status": status,
    }


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    if load_dotenv is not None:
        load_dotenv(Path(__file__).parent / ".env")

    parser = argparse.ArgumentParser(
        description="Export Instapaper bookmarks to Pocket-format CSV."
    )
    parser.add_argument("--consumer-key", default=os.environ.get("INSTAPAPER_CONSUMER_KEY"))
    parser.add_argument("--consumer-secret", default=os.environ.get("INSTAPAPER_CONSUMER_SECRET"))
    parser.add_argument("--username", default=os.environ.get("INSTAPAPER_USERNAME"))
    parser.add_argument("--password", default=os.environ.get("INSTAPAPER_PASSWORD", ""))
    parser.add_argument("output", nargs="?", default="instapaper_pocket.csv")
    args = parser.parse_args()

    missing = [k for k, v in {
        "consumer-key": args.consumer_key,
        "consumer-secret": args.consumer_secret,
        "username": args.username,
    }.items() if not v]
    if missing:
        parser.error(
            f"Missing required credentials: {', '.join(missing)}.\n"
            "Set via --flags or INSTAPAPER_CONSUMER_KEY / INSTAPAPER_CONSUMER_SECRET "
            "/ INSTAPAPER_USERNAME env vars."
        )

    print("Authenticating…")
    token, token_secret = get_access_token(
        args.consumer_key, args.consumer_secret, args.username, args.password
    )
    print("  ✓ Token obtained")

    # Fetch unread, starred (tagged "starred"), archive (status=read)
    folders = [
        ("unread",   "unread",  ""),
        ("starred",  "unread",  "starred"),
        ("archive",  "read",    ""),
    ]

    fields = ["title", "url", "time_added", "cursor", "tags", "status"]
    seen_ids: set[int] = set()
    count = 0

    with open(args.output, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()

        for folder_id, status, extra_tag in folders:
            print(f"Fetching '{folder_id}'…")
            bookmarks = fetch_folder(
                args.consumer_key, args.consumer_secret, token, token_secret, folder_id
            )
            print(f"  ✓ {len(bookmarks)} bookmarks")
            for b in bookmarks:
                bid = b.get("bookmark_id")
                if bid is None:
                    continue
                if bid in seen_ids:
                    continue  # starred items also appear in unread; deduplicate
                seen_ids.add(bid)
                writer.writerow(bookmark_to_row(b, status, extra_tag))
                count += 1

    print(f"\nDone. {count} bookmarks → {args.output}")


if __name__ == "__main__":
    main()
