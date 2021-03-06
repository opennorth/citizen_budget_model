module CitizenBudgetModel
  class OrganizationsController < CitizenBudgetModelController
    before_action :authenticate_user!
    before_action :check_authorization!
    before_action :set_organization, only: [:show, :edit, :update, :destroy]

    def index
      @organizations = Organization.all.sort_by(&:name)
    end

    def show
    end

    def new
      @organization = Organization.new
    end

    def edit
    end

    def create
      @organization = Organization.new(organization_params)

      if @organization.save
        redirect_to @organization, notice: _('Organization was created.')
      else
        render :new
      end
    end

    def update
      if @organization.update(organization_params)
        redirect_to @organization, notice: _('Organization was updated.')
      else
        render :edit
      end
    end

    def destroy
      @organization.destroy
      redirect_to organizations_path, notice: _('Organization was deleted.')
    end

  private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(*Organization.globalize_attribute_names)
    end
  end
end
