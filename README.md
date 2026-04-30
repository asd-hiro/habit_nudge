# BiasHack
### 〜行動経済学に基づき「意志力」をハックする学習習慣化アプリ〜

## 1. アプリ概要
「目標はあるのに、ついスマホを触ってしまう」「二度寝で午前中を無駄にしてしまう」
本アプリは、そんな**人間の不合理な行動**を、大学時代に専修した**「行動経済学」**の知見と**「IT技術」**によって強制的にハックし、学習習慣を定着させるための自己管理システムです。

単なる学習記録ツールに留まらず、ユーザーの心理的バイアスを逆手に取った「仕組み」によって、挫折させない環境を提供します。

---

## 2. 開発背景（解決したい課題）
私はこれまで、「やりたいと思っているのに体が動かない」という深刻な課題を抱えていました。

- **朝の意志力の欠如**: 覚醒直後の低い判断力が二度寝を招く。
- **現在志向バイアス**: 「将来のエンジニア転職」という大きな利益より、「今この瞬間の安眠・娯楽」という小さな快楽を優先してしまう。
- **負の自己肯定感のスパイラル**: 計画倒れを繰り返すことで自信を喪失し、さらなる意欲低下を招く。

これらの課題に対し、精神論（根性）で立ち向かうのではなく、システム側で**「行動せざるを得ない状況」**を作り出す必要があると考え、開発に至りました。

---

## 3. 主要機能（活用した行動経済学理論）

### ① 学習連動型キャラクター育成
- **活用理論：正の強化 / ゲーミフィケーション**
- **内容**: 学習時間に応じた経験値（EXP）が付与され、キャラクターが進化します。努力のプロセスを視覚的な報酬に変換することで、内発的動機付けをサポートします。

### ② 24時間未活動によるペナルティ
- **活用理論：損失回避性**
- **内容**: 人間は「得をすること」よりも「同等の損失を避けること」を優先する性質があります。24時間学習の記録がない場合、キャラクターが衰退（💀）し、蓄積した経験値が減少します。「蓄積を失いたくない」という恐怖を復帰のトリガーとして利用します。

### ③ 二度寝防止の「運命のスロット」
- **活用理論：選択のオーバーロードの回避**
- **内容**: 起きた直後の脳は決断リソースが枯渇しており、それが二度寝の原因となります。スロットによって「今日最初のアクション」を強制的に決定させることで、迷う余地をなくし、スムーズな行動開始を促します。

---

## 4. 技術的なこだわり

### ペナルティロジックのべき等性とデータ整合性
本アプリの核心である「経験値減少」において、ブラウザのリロードのたびにペナルティが重複実行されるバグは、ユーザーの信頼を著しく損なう致命的な問題です。これに対し、以下の設計で**べき等性（何度実行しても結果が変わらない性質）**を確保しました。

- **排他制御の設計**: `characters` テーブルに `last_penalty_at` カラムを実装。
- **判定ロジック**: `(24時間未活動)` かつ `(last_penalty_at が本日より前)` の条件が揃った時のみ実行するようモデル層に実装。
- **データ保護**: 経験値の減少と実行時刻の更新を確実にセットで行うことで、データの不整合を防止。

### MVP（Minimum Viable Product）開発の遂行
就活開始というデッドラインから逆算し、「ユーザーの行動を変えるコア機能は何か」を厳選。複雑な多機能化を避け、バックエンドのロジック精度を高めることにリソースを集中させました。

---

## 5. 技術スタック
- **Backend**: Ruby 3.2.2 / Ruby on Rails 7.0.x
- **Frontend**: HTML5 / CSS3 / JavaScript (Vanilla JS)
- **Database**: PostgreSQL
- **Infrastructure**: Render

---

## 6. 今後の展望
行動経済学のさらなる実装により、継続性を高めるアップデートを予定しています。
- **サンクコスト効果**: 累計学習時間の可視化による「ここまで積み上げたから辞められない」心理の強化。
- **社会的証明**: 他ユーザーの継続状況を可視化し、集団心理による継続率向上を図る。

---

## 7. 結びに代えて（作者より）
私は、IT技術は「人間の不完全さを補完するもの」であると考えています。

大学で学んだ行動経済学の理論をコードに落とし込む過程で、ロジック一つで人の行動（自分自身の習慣）が変わっていく面白さを実感しました。
プログラミングスクールでの10週間、ただ文法を学ぶだけでなく「ユーザーの行動をどう変えるか」を常に問い続けながら開発しました。実務においても、目的意識を持って技術を選定し、課題を解決できるエンジニアを目指します。

## データベース設計

### users テーブル

| Column   | Type   | Options                   |
| -------- | ------ | ------------------------- |
| name     | string | null: false               |
| nickname | string | null: false               |
| email    | string | null: false, unique: true |
| password | string | null: false               |

#### Association

- has_one :character
- has_many :routines
- has_many :study_logs
- has_many :sns_posts

---

### characters テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | string     | null: false                    |
| level  | integer    | null: false, default: 1        |
| exp    | integer    | null: false, default: 0        |
| status | integer    | null: false, default: 0        |
| user   | references | null: false, foreign_key: true |

#### Association

- belongs_to :user

---

### routines テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| content | text       | null: false                    |
| user    | references | null: false, foreign_key: true |

#### Association

- belongs_to :user
- has_many :study_logs

---

### study_logs テーブル

| Column            | Type       | Options                        |
| ----------------- | ---------- | ------------------------------ |
| start_time        | datetime   |                                |
| end_time          | datetime   |                                |
| duration_minutes  | integer    |                                |
| focus_score       | integer    |                                |
| completion_status | integer    | null: false, default: 0        |
| penalty_sent      | boolean    | null: false, default: false    |
| user              | references | null: false, foreign_key: true |
| routine           | references | null: false, foreign_key: true |

#### Association

- belongs_to :user
- belongs_to :routine

---

### sns_posts テーブル

| Column    | Type       | Options                        |
| --------- | ---------- | ------------------------------ |
| post_text | text       | null: false                    |
| user      | references | null: false, foreign_key: true |

#### Association

- belongs_to :user
