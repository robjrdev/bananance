require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "POST #create" do
    let(:user) do
      User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        status: 'approved',
      )
    end
    context "with valid email and password" do
      before do
        post :create, params: { user: { email: user.email, password: user.password } }
      end

      it "sets the user_id in the session" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the dashboard for a regular user" do
        expect(response).to redirect_to(dashboard_path)
      end

      it "redirects to the admin page for an admin user" do
        user.update(admin: true)
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(admin_path)
      end

      it "redirects to the pending page for a user with status 'pending'" do
        user.update(status: 'pending')
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(pending_path)
      end
    end

    context "with invalid email or password" do
      before do
        post :create, params: { user: { email: 'user@example.com', password: 'wrongpassword' } }
      end

      it "does not set the user_id in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "renders the new template with an error message" do
        expect(response).to render_template(:new)
        expect(flash[:notice]).to match(/Email or password is incorrect/)
      end
    end

    context "with empty email or password" do
      before do
        post :create, params: { user: { email: '', password: '' } }
      end

      it "does not set the user_id in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "renders the new template with an error message" do
        expect(response).to render_template(:new)
        expect(flash[:notice]).to match(/Email or password should not be empty/)
      end
    end
  end

  describe "DELETE #destroy" do
       let(:user) do
      User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        status: 'approved',
      )
    end
    
    before do
      session[:user_id] = user.id
      delete :destroy
    end

    it "removes the user_id from the session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root page" do
      expect(response).to redirect_to(root_path)
    end
  end
end
