class Duty < ApplicationRecord
    # TODO: 授業内課題07-1
    belongs_to :member, optional: true #外部キーがnilであってもDBに保存できる
end
