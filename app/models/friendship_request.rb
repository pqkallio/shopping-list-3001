class FriendshipRequest < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  belongs_to :target, :class_name => "User"

  validates :owner, presence: true
  validates :target, presence: true

  before_save :default_status

  UNSEEN = 0
  SEEN = 1
  REJECTED = 2
  ACCEPTED = 3

  scope :unseen, -> { where status:UNSEEN }
  scope :seen, -> { where status:SEEN }
  scope :open, -> { where status:[UNSEEN, SEEN] }
  scope :rejected, -> { where status:REJECTED }
  scope :accepted, -> { where status:ACCEPTED }
  scope :closed, -> { where status:[REJECTED, ACCEPTED] }

  def set_unseen
    self.status = UNSEEN
    self.save
  end

  def set_seen
    self.status = SEEN
    self.save
  end

  def set_rejected
    self.status = REJECTED
    self.save
  end

  def set_accepted
    self.status = ACCEPTED
    self.save
  end

  private

  def default_status
    self.status ||= UNSEEN
  end

end
