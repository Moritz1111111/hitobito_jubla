class Event::Camp::KindsController < CrudController
  
  def create
    super(location: event_camp_kinds_path)
  end
  
  def update
    super(location: event_camp_kinds_path)
  end
    
  private
  
  def list_entries
    super.order(:deleted_at, :label)
  end
  
  def assign_attributes
    super
    entry.deleted_at = nil
  end
  
  def model_scope
    super.with_deleted
  end
  
  class << self
    def model_class
      Event::Camp::Kind
    end
  end
  
end
