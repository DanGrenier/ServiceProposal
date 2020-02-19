class PickProposalTemplatesController < ApplicationController


def index
  #Gather proporal templates for the current logged in user only
  @templates = ProposalTemplate.for_user(current_user.id)
end

def show
end

def new
end

def create
end

def edit
end

def update
end

def destroy
end

end