class DutiesController < ApplicationController
    before_action :login_required

    #当番一覧
    def index
        @duties = Duty.all
    end
end
