# spec/controllers/concerns_controller_spec.rb
require 'rails_helper'

RSpec.describe ConcernsController, type: :controller do
    describe "POST #create" do
      let(:existing_member_email) { "test@example.com" } # Replace with the email of the existing member you want to use
      let(:existing_member) { Member.find_by(email: existing_member_email) } # Add this line to retrieve the existing member

      before do
        # Stub authentication method to return the existing member
        allow(controller).to receive(:authenticate_member!).and_return(true)
        allow(controller).to receive(:current_member).and_return(existing_member)

        Concern.destroy_all
      end
  
      it "creates a new concern for the existing member" do
        # Make sure existing_member is not nil
        expect(existing_member).not_to be_nil

        post :create, params: { member_id: existing_member.id, concern: { title: "Test Concern", description: "Test Description", status: "unread" } }
  
        # Check if the concern was successfully created and associated with the existing member
        expect(Concern.count).to eq(1)
        expect(Concern.first.title).to eq("Test Concern")
        expect(Concern.first.description).to eq("Test Description")
        expect(Concern.first.member).to eq(existing_member)
      end

      it "sorts concerns by title" do
        # Post the first concern
        post :create, params: { member_id: existing_member.id, concern: { title: "Test Concern", description: "Test Description", status: "unread" } }
        post :create, params: { member_id: existing_member.id, concern: { title: "Second Test Concern", description: "Test Description", status: "unread" } }
  
        # Call the sort_by_title action
        get :sort_by_title, params: { member_id: existing_member.id }
  
        # Verify that @concerns are sorted by title
        sorted_concerns = assigns(:concerns)
        expect(sorted_concerns.length).to eq(2)
        expect(sorted_concerns.first.title).to eq("Second Test Concern")
        expect(sorted_concerns.last.title).to eq("Test Concern")
      end

      it "sorts concerns by status and time" do
        # Post the concerns with different statuses
        post :create, params: { member_id: existing_member.id, concern: { title: "Test Concern", description: "Test Description", status: "resolved" } }
        post :create, params: { member_id: existing_member.id, concern: { title: "Second Test Concern", description: "Test Description", status: "unread" } }
        post :create, params: { member_id: existing_member.id, concern: { title: "Third Test Concern", description: "Test Description", status: "read" } }
        post :create, params: { member_id: existing_member.id, concern: { title: "Fourth Test Concern", description: "Test Description", status: "in_progress" } }
      
        # Call the sort_by_status action
        get :sort_by_status, params: { member_id: existing_member.id }
      
        # Verify that @concerns are sorted by status
        sorted_concerns = assigns(:concerns)
        expect(sorted_concerns.length).to eq(4)
      
        # Define the expected order of statuses
        expected_statuses = ["in_progress", "read", "unread", "resolved"]
      
        # Iterate over the sorted concerns and check their statuses
        sorted_concerns.each_with_index do |concern, index|
          expect(concern.status).to eq(expected_statuses[index])
        end

        get :sort_by_time, params: { member_id: existing_member.id }
        sorted_concerns = assigns(:concerns)

        expected_titles = ["Fourth Test Concern", "Third Test Concern", "Second Test Concern", "Test Concern"]

        # Iterate over the sorted concerns and check their titles
        sorted_concerns.each_with_index do |concern, index|
            expect(concern.title).to eq(expected_titles[index])
        end
      end
    end

    describe "PATCH #update" do
        let(:existing_member_email) { "test@example.com" }
        let(:existing_member) { Member.find_by(email: existing_member_email) }

        before do
        allow(controller).to receive(:authenticate_member!).and_return(true)
        allow(controller).to receive(:current_member).and_return(existing_member)
        end

        it "updates the concern" do
            # Create a concern
            post :create, params: { member_id: existing_member.id, concern: { title: "Initial Title", description: "Initial Description", status: "unread" } }
        
            # Retrieve the last created concern
            concern = Concern.last
        
            # Update the concern
            patch :update, params: { member_id: existing_member.id, id: concern.id, concern: { title: "Updated Title", description: "Updated Description", status: "read" } }
        
            # Assertions
            expect(response).to redirect_to(member_concerns_path(existing_member))
            expect(flash[:success]).to eq("Concern updated successfully!")
        
            # Reload the concern from the database to get the updated attributes
            updated_concern = concern.reload
        
            expect(updated_concern.title).to eq("Updated Title")
            expect(updated_concern.description).to eq("Updated Description")
            expect(updated_concern.status).to eq("read")
        end
      

        it "renders the edit template if update fails" do
            # Create a concern
            post :create, params: { member_id: existing_member.id, concern: { title: "Initial Title", description: "Initial Description", status: "unread" } }
        
            # Retrieve the last created concern
            concern = Concern.last
        
            # Attempt to update with invalid parameters
            patch :update, params: { member_id: existing_member.id, id: concern.id, concern: { title: "", description: "", status: "unread" } }
        
            # Assertions
            expect(response).to render_template("edit")
        
            # Ensure the flash error message is set
            expect(flash[:error]).to eq("Failed to update concern")
        
            # Reload the concern from the database to ensure it wasn't updated
            reloaded_concern = concern.reload
        
            expect(reloaded_concern.title).to eq("Initial Title")
            expect(reloaded_concern.description).to eq("Initial Description")
            expect(reloaded_concern.status).to eq("unread")
        end      
        end

    describe "DELETE #destroy" do
        let(:existing_member_email) { "test@example.com" }
        let(:existing_member) { Member.find_by(email: existing_member_email) }

        before do
            allow(controller).to receive(:authenticate_member!).and_return(true)
            allow(controller).to receive(:current_member).and_return(existing_member)
        end

        it "destroys the concern" do
            # Create a concern
            post :create, params: { member_id: existing_member.id, concern: { title: "Test Concern", description: "Test Description", status: "unread" } }

            # Retrieve the last created concern
            concern = Concern.last

            # Delete the concern
            delete :destroy, params: { member_id: existing_member.id, id: concern.id }

            # Assertions
            expect(response).to redirect_to(member_concerns_url(existing_member))
            expect(flash[:notice]).to eq("Concern was successfully destroyed.")
            expect { Concern.find(concern.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end

    describe "set_concerns for admin" do
        let(:existing_member_email) { "test@example.com" }
        let(:existing_member_email_2) { "test2@example.com" }
        let(:admin_email) { "admin@example.com" }
      
        let(:existing_member) { Member.find_by(email: existing_member_email) }
        let(:existing_member_2) { Member.find_by(email: existing_member_email_2) }
        let(:admin) { Member.find_by(email: admin_email) }
      
        before do
          allow(controller).to receive(:authenticate_member!).and_return(true)
          allow(controller).to receive(:current_member).and_return(existing_member)
        end
      
        it "displays concerns from all members for admin" do
          # Create concerns for two different members
          post :create, params: { member_id: existing_member.id, concern: { title: "Test Concern", description: "Test Description", status: "unread" } }
      
          allow(controller).to receive(:current_member).and_return(existing_member_2)
      
          post :create, params: { member_id: existing_member_2.id, concern: { title: "Another Test Concern", description: "Another Test Description", status: "unread" } }

          allow(controller).to receive(:current_member).and_return(admin)
      
          # Call the index action to display concerns for the admin
          get :index, params: { member_id: admin.id }
          concerns = assigns(:concerns)
      
          # Verify that the admin can see concerns from both members
          expect(concerns.count).to eq(2)
          expect(concerns.map(&:member_id)).to include(existing_member.id)
          expect(concerns.map(&:member_id)).to include(existing_member_2.id)
        end
      end
      
      
  end
  
  
  
  
  
