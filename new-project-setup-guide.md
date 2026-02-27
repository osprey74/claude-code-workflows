# 新規プロジェクト Claude Code Skills 導入手順書

> 新しいプロジェクトを立ち上げた際に、Claude Code の共通ワークフロー（Skills）を導入するための手順書です。

**最終更新日**: 2026-02-28
**前提条件**: `claude-code-workflows` リポジトリがローカルにクローン済みであること

---

## 事前準備の確認

以下のツールがインストールされていることを確認してください。

- Claude Code CLI（`claude` コマンド）
- GitHub CLI（`gh` コマンド）— リリース系 Skills で使用
- Git
- Rust / Cargo — Tauri プロジェクトの場合のみ

`claude-code-workflows` のローカルパス（以下、`WORKFLOWS_DIR` と表記）を確認しておいてください。

```
例: G:\dev\claude-code-workflows
```

---

## Step 1: プロジェクトの種別を判定する

作成するプロジェクトに最も近いテンプレートを選びます。

| テンプレート | 用途 | 対象例 |
|---|---|---|
| `CLAUDE_tauri.md` | Tauri + React + TypeScript アプリ | kazahana, mandala-ya |
| `CLAUDE_docs.md` | ドキュメント・仕様書プロジェクト | bsaf-protocol |
| `CLAUDE_bot.md` | Bot / バックエンドサービス | bsaf-jma-bot |

---

## Step 2: Skills をプロジェクトにコピーする

`claude-code-workflows` に含まれる 4 つの Skills をプロジェクトの `.claude/skills/` にコピーします。

### 方法A: setup.sh を使う場合（推奨）

```bash
cd {WORKFLOWS_DIR}
bash setup.sh {新規プロジェクトのパス}
```

実行例:
```bash
cd G:\dev\claude-code-workflows
bash setup.sh G:\dev\my-new-project
```

### 方法B: 手動コピーの場合

```bash
mkdir -p {新規プロジェクト}/.claude/skills
cp -r {WORKFLOWS_DIR}/skills/task-manage     {新規プロジェクト}/.claude/skills/
cp -r {WORKFLOWS_DIR}/skills/commit-push     {新規プロジェクト}/.claude/skills/
cp -r {WORKFLOWS_DIR}/skills/release-draft   {新規プロジェクト}/.claude/skills/
cp -r {WORKFLOWS_DIR}/skills/release-publish {新規プロジェクト}/.claude/skills/
```

### 方法C: Claude Code で実行する場合

プロジェクトディレクトリで Claude Code を起動し、以下のプロンプトを入力:

```
{WORKFLOWS_DIR}\skills\ の中身（task-manage, commit-push, release-draft, release-publish の4ディレクトリ）を .claude/skills/ にコピーしてください
```

### コピー後の確認

以下の構成になっていれば OK です。

```
{新規プロジェクト}/
└── .claude/
    └── skills/
        ├── task-manage/SKILL.md
        ├── commit-push/SKILL.md
        ├── release-draft/SKILL.md
        └── release-publish/SKILL.md
```

---

## Step 3: CLAUDE.md を作成する

CLAUDE.md はプロジェクト固有の設定値を定義するファイルです。Skills はこのファイルを参照して動作します。

### 3-1. テンプレートをコピー

Step 1 で判定したテンプレートをプロジェクトルートにコピーします。

```bash
cp {WORKFLOWS_DIR}/templates/CLAUDE_tauri.md {新規プロジェクト}/CLAUDE.md
```

### 3-2. プロジェクトに合わせて編集

CLAUDE.md をエディタで開き、以下のセクションをプロジェクトの実態に合わせて編集します。

#### Task Management セクション

| 設定項目 | 説明 | 設定例 |
|---|---|---|
| `task_file` | タスクファイルのパス | `docs/tasks.md`, `remaining-work.md` |
| `done_marker` | タスク完了時のマーク | `[x]` または `✅` |
| `progress_summary` | 進捗サマリー更新の有無 | `true` / `false` |

#### Documentation セクション

| 設定項目 | 説明 | 設定例 |
|---|---|---|
| `docs_to_update` | コミット時に更新確認する文書 | `README.md`, `README.ja.md` |
| `doc_pairs` | 同期すべき言語ペア | `README.md ↔ README.ja.md` |

#### Versioning セクション

| 設定項目 | 説明 | 設定例 |
|---|---|---|
| `version_files` | リリース時に必ず更新するファイル | `package.json`, `src-tauri/Cargo.toml`, `src-tauri/tauri.conf.json` |
| `extra_version_files` | プロジェクト固有の追加対象 | `docs/en/guide/index.html` |
| `cargo_lockfile` | Cargo.lock を更新するか | `true` / `false` |

#### CI/CD セクション

| 設定項目 | 説明 | 設定例 |
|---|---|---|
| `cicd` | CI/CD の有無 | `true` / `false` |
| `cicd_trigger` | トリガー方式 | `tag push` |
| `cicd_platform` | プラットフォーム | `GitHub Actions` |

#### SNS セクション

| 設定項目 | 説明 | 設定例 |
|---|---|---|
| `sns_accounts` | リリース告知用アカウント | `Bluesky @handle.bsky.social` |

---

## Step 4: .gitignore を更新する

Claude Code の個人設定ファイルを Git 管理外にします。

```bash
echo ".claude/settings.local.json" >> {新規プロジェクト}/.gitignore
```

---

## Step 5: コミット＆プッシュ

```bash
cd {新規プロジェクト}
git add .claude/ CLAUDE.md .gitignore
git commit -m "feat: add Claude Code workflow skills and project configuration"
git push
```

### Claude Code で実行する場合

プロジェクトディレクトリで Claude Code を起動し:

```
Skills導入ファイルをコミット＆プッシュしてください。メッセージ: "feat: add Claude Code workflow skills and project configuration"
```

---

## Step 6: 動作確認

Claude Code でプロジェクトを開き、以下のプロンプトで各 Skill が動作するか確認します。

| テスト項目 | プロンプト例 | 期待動作 |
|---|---|---|
| タスク管理 | 「テストタスクを追加してください」 | タスクファイルに項目が追加される |
| タスク完了 | 「テストタスクを完了にしてください」 | タスクに完了マークが付く |
| コミット＆プッシュ | 「コミット＆プッシュしてください」 | ドキュメント確認後にコミット＆プッシュ |
| リリースドラフト | 「v0.1.0をリリースします」 | バージョン更新、タグ作成、ドラフト作成 |
| リリース公開 | 「ドラフト版の完成を確認しました」 | リリースノート添付、公開、SNS文面作成 |

---

## Step 7: テンプレートリポジトリの更新（任意）

新規プロジェクト用に CLAUDE.md の実例を作成した場合、`claude-code-workflows` リポジトリにも保存しておくと次回以降の参考になります。

```bash
cd {WORKFLOWS_DIR}
mkdir -p projects/{新規プロジェクト名}
cp {新規プロジェクト}/CLAUDE.md projects/{新規プロジェクト名}/CLAUDE.md
git add projects/{新規プロジェクト名}/
git commit -m "docs: add {新規プロジェクト名} project configuration"
git push
```

---

## クイックリファレンス（全手順サマリー）

```bash
# 1. Skills をコピー
cd {WORKFLOWS_DIR}
bash setup.sh {新規プロジェクトのパス}

# 2. CLAUDE.md をコピー＆編集
cp {WORKFLOWS_DIR}/templates/CLAUDE_{種別}.md {新規プロジェクト}/CLAUDE.md
# → エディタで編集

# 3. .gitignore を更新
echo ".claude/settings.local.json" >> {新規プロジェクト}/.gitignore

# 4. コミット＆プッシュ
cd {新規プロジェクト}
git add .claude/ CLAUDE.md .gitignore
git commit -m "feat: add Claude Code workflow skills and project configuration"
git push

# 5. (任意) テンプレートリポジトリに実例を追加
cd {WORKFLOWS_DIR}
mkdir -p projects/{新規プロジェクト名}
cp {新規プロジェクト}/CLAUDE.md projects/{新規プロジェクト名}/CLAUDE.md
git add . && git commit -m "docs: add {新規プロジェクト名} config" && git push
```

---

## 参照リンク

- テンプレートリポジトリ: https://github.com/osprey74/claude-code-workflows
- Claude Code Skills ドキュメント: https://code.claude.com/docs/en/slash-commands
- GitHub CLI: https://cli.github.com/
