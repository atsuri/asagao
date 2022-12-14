class Member < ApplicationRecord
    has_secure_password

    has_many :entries, dependent: :destroy
    has_one_attached :profile_picture
    attribute :new_profile_picture
    attribute :remove_profile_picture, :boolean

    # TODO: 授業内課題10-1
    attribute :new_duty_ids, :intarray, default: []
    after_initialize do
        if new_duty_ids
            self.new_duty_ids.replace(self.duty_ids)
        end
    end

    has_many :votes, dependent: :destroy
    has_many :voted_entries, through: :votes, source: :entry

    # TODO: 授業内課題07-1
    has_many :duties, dependent: :nullify
    
    validates :number, presence: true,
        numericality: {
            only_integer: true,
            greater_than: 0,#1以上
            less_than: 100,#100未満
            allow_blank: true
        },
        uniqueness: true
    validates :name, presence: true,
        format: {
            with: /\A[A-Za-z][A-Za-z0-9]*\z/,
            allow_blank: true,
            message: :invalid_member_name
        },
        length: { minimum: 2, maximum: 20, allow_blank: true },
        uniqueness: { case_sensitive: false }
    validates :full_name, presence: true, length: { maximum: 20 }
    validates :email, email: { allow_blank: true }

    attr_accessor :current_password
    validates :password, presence: { if: :current_password }

    validate if: :new_profile_picture do
        if new_profile_picture.respond_to?(:content_type)
            unless new_profile_picture.content_type.in?(ALLOWED_CONTENT_TYPES)
                errors.add(:new_profile_picture, :invalid_image_type)
            end
        else
            errors.add(:new_profile_picture, :invalid)
        end
    end

    # TODO: 授業内課題10-1
    validate do
        new_duty_ids.each do |i|
            who = Duty.find(i).member_id #誰がその当番になっているか
            if who != nil && who != self.id
                errors.add(:new_duty_ids, :invalid_duty)
            end
        end
    end

    before_save do
        if new_profile_picture
            self.profile_picture = new_profile_picture
        elsif remove_profile_picture
            self.profile_picture.purge
        end

        # TODO: 授業内課題10-1
        # if new_duty_ids #ずっとtrue
        self.duty_ids = new_duty_ids
        # end
    end
    
    # TODO: 授業内課題05-2
    validates :birthday, date:{ before: Proc.new{ Date.today } }

    def votable_for?(entry)
        entry && entry.author != self && !votes.exists?(entry_id: entry.id)
    end
    
    class << self
        def search(query)
            rel = order("number")
            if query.present?
                rel = rel.where("name LIKE ? OR full_name LIKE ?",
                    "%#{query}%", "%#{query}%")
            end
            rel
        end
    end
end
