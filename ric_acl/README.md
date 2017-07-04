# RicAcl

RicAcl implements access control list as configurable module. 

## Usage

### Example: Privilege definition

Table `roles`:

| id | name                 |
| -- | -------------------- |
| 1  | Admin                |
| 2  | Simple User          |
| 3  | Organization Manager |

Table `privileges`:

| owner_id | owner_type | subject_type | scope_type   | action  |
| -------- | ---------- | ------------ | ------------ | ------- |
| 1        | Role       | Sample       |              | load    |
| 1        | Role       | Sample       |              | create  |
| 1        | Role       | Sample       |              | update  |
| 1        | Role       | Sample       |              | destory |
| 2        | Role       | Sample       | owner        | load    |
| 2        | Role       | Sample       | owner        | create  |
| 2        | Role       | Sample       | owner        | update  |
| 2        | Role       | Sample       | owner        | destroy |
| 3        | Role       | Sample       | organization | load    |
| 3        | Role       | Sample       | organization | create  |
| 3        | Role       | Sample       | organization | update  |
| 3        | Role       | Sample       | organization | destroy |


### Example 1: Simple not scoped model authorization

```ruby
class SamplesController < ApplicationController
    
    before_action :set_sample, only: [:show, :edit, :update, :destroy]

    # *************************************************************************
    # Authorization
    # *************************************************************************

    before_action only: [:index] do
        RicAcl.authorize!(
            user: current_user,
            subject: Sample,
            action: :load
        )
        # or simply: Sample.authorize!(user: current_user, action: :load)
    end

    before_action only: [:show] do
        RicAcl.authorize!(
            user: current_user,
            subject: @sample,
            action: :load
        )
        # or simply: @sample.authorize!(user: current_user, action: :load)
    end

    before_action only: [:new, :create] do
        RicAcl.authorize!(
            user: current_user,
            subject: Sample,
            action: :create
        )
        # or simply: Sample.authorize!(user: current_user, action: :create)
    end

    before_action only: [:edit, :update] do
        RicAcl.authorize!(
            user: current_user,
            subject: @sample,
            action: :update
        )
        # or simply: @sample.authorize!(user: current_user, action: :update)
    end

    before_action only: [:destroy] do
        RicAcl.authorize!(
            user: current_user,
            subject: @sample,
            action: :destroy
        )
        # or simply: @sample.authorize!(user: current_user, action: :destroy)
    end

    # *************************************************************************
    # Actions
    # *************************************************************************

    def index
        ...
    end

    def show
        ...
    end

    def new
        ...
    end

    def edit
        ...
    end

    def create
        ...
    end

    def update
        ...
    end

    def destroy
        ...
    end

protected

    def set_sample
        @sample = ...
    end

end
```

### Example 2: Model authorization scoped by owner

```ruby
class Sample < ActiveRecord::Base
    belongs_to :owner, class_name: "User"

    # *************************************************************************
    # Authorization
    # *************************************************************************

    include RicAcl::Concerns::Models::Authorizable

    authorization_scope_query :owner do |user| # Must be defined if scoped :load action can be used
        where(owner_id: user.id) 
    end
    authorization_scope_setter :owner do |user| # Must be defined if scoped :create action can be used
        self.owner_id = user.id
    end

end
```

```ruby
class SamplesController < ApplicationController
    
    before_action :set_sample, only: [:show, :edit, :update, :destroy]

    # *************************************************************************
    # Authorization
    # *************************************************************************

    before_action only: [:index] do
        Sample.authorize!(user: current_user, scope: :owner, action: :load)
    end

    before_action only: [:show] do
       @sample.authorize!(user: current_user, scope: :owner, action: :load)
    end

    before_action only: [:new, :create] do
        Sample.authorize!(user: current_user, scope: :owner, action: :create)
    end

    before_action only: [:edit, :update] do
        @sample.authorize!(user: current_user, scope: :owner, action: :update)
    end

    before_action only: [:destroy] do
        @sample.authorize!(user: current_user, scope: :owner, action: :destroy)
    end

    # *************************************************************************
    # Actions
    # *************************************************************************

    def index
        @samples = Sample.authorized_for(user: current_user, scope: :owner)... # Select only owner's
    end

    def show
        ...
    end

    def new
        ... 
    end

    def edit
        ...
    end

    def create
        @sample = Sample.new(sample_params)
        @sample.authorize_for(user: current_user, scope: :owner) # Force correct owner
        ...
    end

    def update
        ...
    end

    def destroy
        ...
    end

protected

    def set_sample
        @sample = ...
    end

end
```

### Example 3: Model authorization scoped by more complicated structure

```ruby
class User < ActiveRecord::Base
    has_and_belongs_to_many :organizations

    def current_organization
        ... # Get current working organization
    end
end
```

```ruby
class Sample < ActiveRecord::Base
    belongs_to :organization

    # *************************************************************************
    # Authorization
    # *************************************************************************

    include RicAcl::Concerns::Models::Authorizable

    authorization_scope_query :organization do |user|
        where(organization_id: user.current_organization.id)
    end
    authorization_scope_query_setter :owner do |user|
        self.organization_id = user.current_organization.id
    end

end
```

```ruby
class SamplesController < ApplicationController
    
    before_action :set_sample, only: [:show, :edit, :update, :destroy]

    # *************************************************************************
    # Authorization
    # *************************************************************************

    before_action only: [:index] do
        Sample.authorize!(user: current_user, scope: :organization, action: :load)
    end

    before_action only: [:show] do
       @sample.authorize!(user: current_user, scope: :organization, action: :load)
    end

    before_action only: [:new, :create] do
        Sample.authorize!(user: current_user, scope: :organization, action: :create)
    end

    before_action only: [:edit, :update] do
        @sample.authorize!(user: current_user, scope: :organization, action: :update)
    end

    before_action only: [:destroy] do
        @sample.authorize!(user: current_user, scope: :organization, action: :destroy)
    end

    # *************************************************************************
    # Actions
    # *************************************************************************

    def index
        @samples = Sample.authorized_for(user: current_user, scope: :organization)... # Select only models which belongs to the same organization as user
    end

    def show
        ...
    end

    def new
        ...
    end

    def edit
        ...
    end

    def create
        @sample = Sample.new(sample_params)
        @sample.authorize_for(user: current_user, scope: :organization) # Force correct organization according to user
        ...
    end

    def update
        ...
    end

    def destroy
        ...
    end

protected

    def set_sample
        @sample = ...
    end

end
```
