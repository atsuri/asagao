class MembersController < ApplicationController
    #会員一覧
    def index
        @members = Member.order("number")
    end

    #検索
    def search
        @members = Member.search(params[:q]) 
        # TODO: 授業内課題04
        if params[:m].present? || params[:w].present?
            @members = @members.where(sex: [params[:m], params[:w]])
        end

        render "index"
    end

    def show
        @member = Member.find(params[:id])
    end

    def new
    end

    def edit
    end
    
    def create
    end

    def update
    end

    def destroy
    end
end
