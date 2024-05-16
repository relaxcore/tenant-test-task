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
