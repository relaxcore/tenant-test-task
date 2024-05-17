## Test task

List of available data types:
* string
* string_required
* number
* number_required
* single_select
* single_select_required
* multi_select
* multi_select_required

P.S: `*_required` types were added just for fun, that was not a test task requirement

Example of `data_structure` attribute:
```
  {
    'First name' => 'string_required',
    'Last name' => 'string',
    'Phone number' => 'number_required',
    'Year of birth' => 'number',
    'Gender' => 'single_select_required',
    'Preferable type of work' => 'single_select',
    'Skills' => 'multi_select_required',
    'Hobbies' => 'multi_select'
  }
```

Example of `select_options` attribute:
```
{
  'Gender' => 'Male',
  'Skills' => ['Ruby', 'Elixir', 'SQL']
}
```

Pay attention, that keys in `select_options` with list of options must be the same as in the `data_structure`


## How to set up a project
1. Clone the repo
```
git clone git@github.com:relaxcore/tenant-test-task.git
```
2. Create and setup the database
```
rails db:create
rails db:migrate
rails db:seed
```
3. Install the Ruby 3.3.1 or switch to it if it's already installed
4. Install all the dependencies
```
bundle install
```
5. Boot up a server
```
rails s
```

## How to test
Do an PUT HTTP request to `localhost:3000/users` with `Authorization` header as `token` (default value of the test user from seed file) with such body structure:
```
{
  tenant_id: UUID,
  data: {
    tenant_custom_field_name1: value,
    tenant_custom_field_name2: value,
    ...
  }
}
```

## Response example
```
{
    "id": "7a8c48e1-da5b-4ed0-9f57-7857dbb3fc99",
    "data": {
        "First name": "First",
        "Gender": "Male",
        "Skills": [
            "Ruby",
            "Python"
        ],
        "Phone number": 123,
        "Last name": "Last",
        "Preferable type of work": "Office",
        "Hobbies": [
            "Chess",
            "Videogames"
        ],
        "Year of birth": 1996
    },
    "data_structure": {
        "Gender": "single_select_required",
        "Skills": "multi_select_required",
        "Hobbies": "multi_select",
        "Last name": "string",
        "First name": "string_required",
        "Phone number": "number_required",
        "Year of birth": "number",
        "Preferable type of work": "single_select"
    },
    "select_options": {
        "Gender": [
            "Male",
            "Female"
        ],
        "Skills": [
            "Ruby",
            "Python",
            "JavaScript",
            "Java",
            "Elixir",
            "SQL",
            "Go",
            "Rust"
        ],
        "Hobbies": [
            "Reading",
            "Drawing",
            "Dancing",
            "Videogames",
            "Photography",
            "Chess"
        ],
        "Preferable type of work": [
            "Office",
            "Hybrid",
            "Home"
        ]
    }
}
```