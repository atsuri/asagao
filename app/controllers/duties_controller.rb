class DutiesController < ApplicationController
    before_action :login_required

    #当番一覧
    def index
        @duties = Duty.all
    end

    #当番詳細
    def show
        duties = Duty.all
        @duties = duties.find(params[:id])
    end
end
