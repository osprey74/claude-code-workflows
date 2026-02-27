# {PROJECT_NAME}

> {PROJECT_DESCRIPTION}

## Task Management

- **task_file**: `{path/to/task-file.md}`
- **done_marker**: `[x]` or `✅`
- **progress_summary**: true/false (タスクファイル内の進捗サマリー数値を更新するか)

## Documentation

- **docs_to_update**:
  - `README.md` (EN)
  - `README.ja.md` (JA)
  - {追加のドキュメントがあればここに記載}
- **doc_pairs** (片方を更新したら同期するペア):
  - `README.md` ↔ `README.ja.md`
  - {追加のペアがあればここに記載}

## Versioning

- **version_files** (リリース時に必ず更新):
  - `package.json`
  - `src-tauri/Cargo.toml`
  - `src-tauri/tauri.conf.json`
- **extra_version_files** (プロジェクト固有の追加対象):
  - {例: docs/en/guide/index.html}
- **cargo_lockfile**: true (Cargo.lock を `cargo generate-lockfile` で更新)

## CI/CD

- **cicd**: true
- **cicd_trigger**: tag push
- **cicd_platform**: GitHub Actions
- **cicd_note**: タグプッシュで自動ビルド＆ Release ドラフト作成

## SNS

- **sns_accounts**:
  - {例: Bluesky @handle.bsky.social}
