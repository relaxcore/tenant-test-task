## Test task

Example of `data_structure` attribute:
```
  {
    'Name' => 'string',
    'Age' => 'number',
    'Phone number' => 'number',
    'Question #1' => 'single_select',
    'Question #2' => 'multi_select'
  }
```

Example of `select_options` attribute:
```
{
  'Question #1' => ['option1', 'option2', 'option3'],
  'Question #2' => ['option1', 'option2', 'option3', 'option4', 'option5']
}
```

Pay attention, that keys in `select_options` with list of options must be the same as in the `data_structure`
