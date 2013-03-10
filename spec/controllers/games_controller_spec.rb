require 'spec_helper'

describe GamesController do

  describe 'GET /games (games#index)' do
    before(:each) do
      get :index
    end

    it 'should set the @games instance variable to a set of all Games' do
      assigns[:games].should_not be_nil
      assigns[:games].all? {|game| game.kind_of?(Game)}.should be_true
    end

    it 'should return status code 200 when successful' do
      response.status.should == 200
    end

  end

  describe 'GET /games/new (games#new)' do
    before(:each) do
      get :new
    end

    it 'should set the @game variable to a new game' do
      assigns[:game].try(:kind_of?, Game).should be_true
      assigns[:game].try(:persisted?).should be_false
    end

    it 'should return the status code 200 when successful' do
      response.status.should == 200
    end
  end

  describe 'GET /games/:id (games#show)' do
    describe 'with valid params' do
      before(:each) do
        @game_id = Game.create!.id
        get :show, :id => @game_id
      end

      it 'should set the @game instance variable' do
        assigns[:game].try(:kind_of?, Game).should be_true
        assigns[:game].should == Game.find(@game_id)
      end

      it 'should status code 200 if successful' do
        response.status.should == 200
      end
    end

    describe 'with invalid params' do
      before(:each) do
        Game.create!
        invalid_id = (Game.last.id + 1)
        get :show, :id => invalid_id
      end

      it 'should return 404 if :id does not exist' do
        response.status.should == 404
      end
    end

  end

  describe 'POST /games (games#create)' do
    before(:each) do
      @game_count =  Game.count
      post :create
    end

    it 'should create a new game' do
      Game.count.should == (@game_count + 1)
    end

    it 'should status 201 if resource created' do
      response.status.should == 201
    end

  end

  describe 'DELETE /games/:id (games#destroy)' do
    describe 'with valid params' do
      before(:each) do
        @game_id = Game.create!.id
        delete :destroy, :id => @game_id
      end

      it 'should destroy the object' do
        Game.exists?(@game_id).should be_false
      end

      it 'should return 200 if deletion successful' do
        response.status.should == 200
      end
    end

    describe 'with invalid params' do
      before(:each) do
        Game.create!
        delete :destroy, :id => (Game.last.id + 1)
      end

      it 'should return 404 status code if :id does not exist' do
        response.status.should == 404
      end
    end
  end

  describe 'POST /games/:id/move (games#move)' do
    describe 'with valid params' do
      before(:each) do
        @game = Game.create!
        Game.stub(:find, @game.id).and_return(@game)
        @game.should_receive(:make_move).and_return(true)
        post :move, :id => @game.id,
                    :player => %w(red blue).sample,
                    :column => (0...Game::NUM_COLUMNS)
      end

      it 'should call #make_move' do end


      it 'should return a status of 200' do
        response.status.should == 200
      end
    end

    describe 'with invalid params' do

      it 'should return 404 and {:success => false} if :id does not exist' do
        Game.create!
        post :move, :id => (Game.last.id + 1)
        response.status.should == 404

      end

      it 'should return 400 and {:success => false} if make move is unsuccessful' do
        @game = Game.create!
        Game.stub(:find, @game.id).and_return(@game)
        @game.should_receive(:make_move).and_return(false)

        post :move, :id => @game.id
        response.status.should == 400

      end
    end
  end


end

