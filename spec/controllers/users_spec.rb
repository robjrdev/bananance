require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    let(:user_params) do
        {
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          password_confirmation: 'password123',
        }
      end
      let(:user) do
        User.create(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          password_confirmation: 'password123',
        )
      end

    describe "#new" do
      context "when user is not logged in" do
        it "renders the new template" do
          get :new
          expect(response).to render_template(:new)
        end
      end
      
      context "when user is logged in and not an admin" do
        it "redirects to dashboard_path" do
          allow(controller).to receive(:current_user).and_return(user)
          get :new
          expect(response).to redirect_to(dashboard_path)
        end
      end
    end
    
    describe "#create" do
      context "when valid user attributes are passed" do
        it "creates a new user" do
          expect {
            post :create, params: {user: user_params}
          }.to change(User, :count).by(1)
        end
        
        it "sends notifications to the new user" do
          expect_any_instance_of(User).to receive(:send_notifications)
          post :create, params: {user: user_params}
        end
        
        it "redirects to sign_in_path" do
          post :create, params: {user: user_params}
        end
      end
      
      context "when invalid user attributes are passed" do
        it "renders the new template with unprocessable_entity status" do
          post :create, params: { user: {email: nil}}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "#edit" do
  
        context "when user is not logged in" do
          it "redirects to sign_in_path" do
            get :edit, params: { id: user.id }
            expect(response).to redirect_to(sign_in_path)
          end
        end
        
        context "when user is logged in and not an admin" do
          it "finds the correct user" do
            allow(controller).to receive(:current_user).and_return(user)
            get :edit, params: { id: user.id }
            expect(assigns(:user)).to eq(user)
          end
      
          it "renders the edit template" do
            allow(controller).to receive(:current_user).and_return(user)
            get :edit, params: { id: user.id }
            expect(response).to render_template(:edit)
          end
        end
      end
      
    
      describe "#update" do
        def login(user)
            session[:user_id] = user.id
          end
          before do
            login(user)
          end
        context "when valid user attributes are passed" do
            it "updates the user" do
                put :update, params: { id: user.id, user: { first_name: "New Name", last_name: user.last_name, email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
                user.reload
                expect(user.first_name).to eq("New Name")
              
              end
              
          it "redirects to admin_path" do
            put :update, params: { id: user.id, user: user_params }
            expect(response).to redirect_to(admin_path)
          end
        
            context "when invalid user attributes are passed" do
              it "renders the edit template with unprocessable_entity status" do
               put :update, params: { id: user.id, user: {email: nil} }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response).to render_template(:edit)
            end
            end
        end
      
    
    describe "#update_status" do
        def login(user)
            session[:user_id] = user.id
          end
          before do
            login(user)
          end
        context "when user status is successfully updated" do
          
          it "updates the user status" do
            put :update_status, params: { id: user.id, user: { status: 'approved'} }
            user.reload
            expect(user.status).to eq('approved')
          end
          it "redirects to the admin dashboard" do
            put :update_status, params: { id: user.id }
            expect(response).to redirect_to(admin_path)
          end
        end
      end
    end
      

    describe "#destroy" do
        def login(user)
            session[:user_id] = user.id
        end
        before do
            login(user)
        end
        it "deletes the user" do
            expect {
            delete :destroy, params: { id: user.id }
            }.to change(User, :count).by(-1)
        end
        it "redirects to the admin dashboard" do
            delete :destroy, params: { id: user.id }
            expect(response).to redirect_to(admin_path)
        end
    end
end
        
  