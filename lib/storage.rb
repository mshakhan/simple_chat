class Storage
  def initialize
    @storage = {}
  end
  
  def create_room
    room_id = generate_room_id
    @storage[room_id] ||= []
    room_id
  end
  
  def remove_room(room_id)
    @storage[room_id] = nil
  end
  
  def add(room_id, user, message)
    if @storage[room_id]
      @storage[room_id] << [user, message, Time.now.to_i]
      true
    else
      false
    end
  end
  
  def get_last(room_id, user, last_time)
    if room_id && @storage[room_id] && user
      messages = @storage[room_id].select do |msg|
        msg.last > last_time
      end
      { :time => Time.now.to_i, :messages => (messages || []) }
    else
      false
    end
  end
  
  protected
  def generate_room_id
    rand(1e10).to_s(36)
  end
end
