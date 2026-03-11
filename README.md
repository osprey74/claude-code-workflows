# claude-code-workflows

Reusable [Claude Code Skills](https://code.claude.com/docs/en/slash-commands) for common development workflows.

These skills automate routine development tasks — task management, commit & push, release drafting, and release publishing — across multiple projects via natural language triggers in Claude Code.

## Overview

### Skills

| Skill | Trigger Examples | Description |
|---|---|---|
| `task-manage` | 「タスクを追加してください」「タスクを完了にして」 | タスクリストの追加・完了管理 |
| `commit-push` | 「コミット＆プッシュしてください」 | ドキュメント更新確認 → コミット → プッシュ |
| `release-draft` | 「v1.1.0をリリースします」 | バージョン更新 → リリースノート作成 → タグ → ドラフト |
| `release-publish` | 「ドラフト版の完成を確認しました」 | リリースノート添付 → 公開 → SNS告知メッセージ作成 |

### Architecture

```
claude-code-workflows/          ← このリポジトリ (テンプレート)
├── skills/                     ← 共通 Skills（プロジェクト変数は CLAUDE.md 参照）
│   ├── task-manage/SKILL.md
│   ├── commit-push/SKILL.md
│   ├── release-draft/SKILL.md
│   └── release-publish/SKILL.md
├── templates/                  ← CLAUDE.md テンプレート
│   ├── CLAUDE_tauri.md
│   ├── CLAUDE_docs.md
│   └── CLAUDE_bot.md
├── projects/                   ← プロジェクト別 CLAUDE.md（実例）
│   ├── kazahana/CLAUDE.md
│   ├── mandala-ya/CLAUDE.md
│   ├── bsaf-protocol/CLAUDE.md
│   └── bsaf-jma-bot/CLAUDE.md
├── setup.sh                    ← インストールスクリプト
└── README.md
```

**設計思想**: Skills 本体は汎用的に書き、プロジェクト固有の設定値（タスクファイルのパス、バージョン管理対象ファイル等）は各リポジトリの `CLAUDE.md` で定義する。

## Setup

### 1. Skills をプロジェクトにインストール

```bash
# このリポジトリをクローン
git clone https://github.com/osprey74/claude-code-workflows.git

# 対象プロジェクトに Skills をコピー
cd claude-code-workflows
bash setup.sh /path/to/your-project
```

### 2. CLAUDE.md を配置

```bash
# テンプレートからコピー（プロジェクトタイプに合わせて選択）
cp templates/CLAUDE_tauri.md /path/to/your-project/CLAUDE.md

# または、既存の実例をコピー
cp projects/kazahana/CLAUDE.md /path/to/kazahana/CLAUDE.md
```

`CLAUDE.md` をプロジェクトに合わせて編集してください。

### 3. Git にコミット

```bash
cd /path/to/your-project
git add .claude/ CLAUDE.md
git commit -m "feat: add Claude Code workflow skills"
git push
```

これで、`git clone` した環境で即座に Skills が使えるようになります。

## CLAUDE.md で定義するプロジェクト固有値

Skills は以下のセクションを CLAUDE.md から参照します:

| セクション | 参照する Skill | 定義内容 |
|---|---|---|
| `## Task Management` | `task-manage` | タスクファイルパス、完了マーク形式 |
| `## Documentation` | `commit-push` | 更新すべきドキュメント一覧、言語ペア |
| `## Versioning` | `release-draft` | バージョン更新対象ファイル |
| `## CI/CD` | `release-draft` | CI/CD 有無、トリガー方式 |
| `## SNS` | `release-publish` | SNS 告知用アカウント情報 |

## Requirements

- [Claude Code](https://code.claude.com/) CLI
- [GitHub CLI (`gh`)](https://cli.github.com/) — リリース系 Skills で使用
- Rust / Cargo — Tauri プロジェクトのバージョン更新で使用

## Support

If you find this project useful, consider supporting its development:

[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support-ff5e5b?logo=ko-fi)](https://ko-fi.com/osprey74)

## License

MIT
