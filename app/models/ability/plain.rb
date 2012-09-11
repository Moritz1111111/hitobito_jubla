class Ability::Plain < Ability::Base
  def initialize(user)
    super(user)
    
    ### GROUPS
    
    can :read, Group

    # Creating and modifiying groups is only handled in Ability::WithGroup
    
    
    ### PEOPLE
    
    can :show, Person do |person|
      can_show_person?(person)
    end
    
    if detail_person_permissions?
      # View all person details
      can :detail, Person do |person| 
        can_detail_person?(person)
      end
    end
    can :detail, Person do |person|
      person == user
    end
    
    if modify_permissions?
      can :create, Person
      can :modify, Person do |person| 
        can_modify_person?(person)
      end
    end
    can :modify, Person do |person|
      person == user
    end
     
  end
  
  private
  
  def can_show_person?(person)
    # both have contact data visible
    (person.contact_data_visible? && user.contact_data_visible?) ||
    # person in same group
    contains_any?(person.groups, user.groups) ||
    
    (layers_read.present? && (
      # user has layer_full or layer_read, person in same layer
      contains_any?(layers_read, person.layer_groups) ||

      # user has layer_full or layer_read, person below layer and visible_from_above
      contains_any?(layers_read, person.above_groups_visible_from)
    ))
  end
  
  def can_detail_person?(person)
    # user has group_full, person in same group
    contains_any?(person.groups, groups_group_full) ||
    
    (layers_read.present? && (
      # user has layer_full or layer_read, person in same layer
      contains_any?(layers_read, person.layer_groups) ||

      # user has layer_full or layer_read, person below layer and visible_from_above
      contains_any?(layers_read, person.above_groups_visible_from)
    ))
  end
  
  def can_modify_person?(person)
    # user has group_full, person in same group
    contains_any?(person.groups, groups_group_full) ||
    
    (layers_full.present? && (
      # user has layer_full, person in same layer
      contains_any?(layers_full, person.layer_groups) ||
      
      # user has layer_full, person below layer and visible_from_above
      contains_any?(layers_full, person.above_groups_visible_from)
    ))
  end
  
  def detail_person_permissions?
    @groups_group_full.present? || @groups_layer_full.present? || @groups_layer_read.present?
  end
  
end