# dashing-pingdom

Set of pingdom widgets to Shopify Dashing (http://shopify.github.io/dashing/).


##  Setup


- Copy the contents of the *jobs*, *widgets* and *config* folder into the the jobs, widgets and config (maybe you need create it) folders in your dashing project.

- Edit the pingdom.yml file to configure the checks. The configuration looks like this:

```yaml
checks:
  - 00000
```
- Configure your credencials. It is not recommended add password directly in the configuration files. So, a good solution is to use *dotenv gem* when you are working on development and environment variables for production.

Add it to dashing's development group gemfile:

```ruby
gem 'dotenv'
```

and run `bundle install`.

Now just add your passwords in the `.env` file. This file should NEVER be versioned.

- Edit your *gemfile* to add dependencies:

```ruby
gem 'pingdom-ruby', :git => "https://github.com/tamaloa/pingdom-ruby.git"
gem 'activesupport'
gem 'time_diff'
gem 'rest-client'
```
and run `bundle install`.


## The widgets


### Pingdom Status

Widget to display Pingdom Status of a specific check.

#### Appearance

![image](https://cloud.githubusercontent.com/assets/496442/2828620/c988e8ec-cf96-11e3-8254-85d78fd972f1.png)

#### Adding this widget to your dashboard

Add the following to your *dashboard.erb* file, and adjust the attributes to place it where you want. The *data-id* value is ended by the ID of the check (same used in pingdom.yml).

```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="pingdom-status-ID" data-view="Pingdomstatus" data-title="Status Title"></div>
</li>
```

### Pingdom Uptime

Widget to display Pingdom Uptime of a specific check.

#### Appearance

![image](https://cloud.githubusercontent.com/assets/496442/2850081/446bb646-d0f2-11e3-9b3c-ecabdbfaf484.png)

#### Adding this widget to your dashboard

Add the following to your *dashboard.erb* file, and adjust the attributes to place it where you want. The *data-id* value is ended by the ID of the check (same used in pingdom.yml).

```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="pingdom-uptime-ID" data-view="Pingdomuptime" data-title="Uptime Title"></div>
</li>
```

## For best viewing

The layout of these widgets is inspired by [Geckoboard](http://geckoboard.com). So, for best viewing is strongly recommended to change the dimensions of standard widgets. To do this, edit the file `assets/application.coffee` for something like:

```coffee
Dashing.widget_base_dimensions ||= [230, 230]
Dashing.numColumns ||= 5
```

## Inspirations

This widgets was inspired by:
- https://github.com/pydubreucq/dashing-pingdom-uptime


## Licence

This widget is released under the [MIT License](http://www.opensource.org/licenses/MIT).
