require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:wiki) { create(:wiki) }


  context "guest" do
    describe "GET show" do
      it "returns HTTP success" do
        get :show, params: { id: wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, params: { id: wiki.id }
        expect(response).to render_template :show
      end

      it "assigns wiki to @wiki" do
        get :show, params: { id: wiki.id }
        expect(assigns(:wiki)).to eq(wiki)
      end
    end

    describe "GET new" do
      it "returns HTTP redirect" do
        get :new, params: { id: wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET edit" do
      it "returns HTTP redirect" do
        get :edit, params: { id: wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE destroy" do
      it "returns HTTP redirect" do
        get :destroy, params: { id: wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


  context "standard user" do
    before do
      @user = User.create( name: 'test', email: 'testuser@test.com', password: 'password' )
      sign_in @user, scope: :user
    end

    describe "GET show" do
      it "returns HTTP success" do
        get :show, params: { id: wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, params: { id: wiki.id }
        expect(response).to render_template :show
      end

      it "assigns wiki to @wiki" do
        get :show, params: { id: wiki.id }
        expect(assigns(:wiki)).to eq(wiki)
      end
    end

    describe "GET new" do
      it "returns HTTP success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of Wikis by 1" do
        expect { post :create, params: { wiki: { title: wiki.title, body: wiki.body }}}.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: { title: wiki.title, body: wiki.body }}
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: { title: wiki.title, body: wiki.body }}
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns HTTP success" do
        get :edit, params: { id: wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { id: wiki.id }
        expect(response).to render_template :edit
      end

      it "assigns the wiki to be updated to @wiki" do
        get :edit, params: { id: wiki.id }
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq wiki.id
        expect(wiki_instance.title).to eq wiki.title
        expect(wiki_instance.body).to eq wiki.body
      end
    end

  end


end
