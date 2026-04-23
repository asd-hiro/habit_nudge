## データベース設計

### users テーブル

| Column   | Type   | Options                   |
| -------- | ------ | ------------------------- |
| name     | string | null: false               |
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