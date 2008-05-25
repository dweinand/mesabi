require File.join(File.dirname(__FILE__), '..', 'lib', 'mesabi')
require 'benchmark'

TIMES = (ARGV[0] || 100_000).to_i

resources = %w(foo bar baz chunky bacon apple banana thing deal widget gizmo gadget object)

route_map =  Mesabi::RouteMap.new do |map|
  resources.each do |resource|
    map.send("#{resource}s", "#{resource}s", {'controller' => resource, 'action' => 'index'})
    map.send("new_#{resource}", "#{resource}s/new", {'controller' => resource, 'action' => 'new'})
    map.send("edit_#{resource}", "#{resource}s/edit", {'controller' => resource, 'action' => 'edit'})
    map.send("#{resource}", "#{resource}s/:id", {'controller' => resource, 'action' => 'show'})
  end
end

resources.each do |resource|
  Benchmark.bm do |x|
    x.report("#{resource}: index") { TIMES.times { route_map.recognize("#{resource}s") } }
    x.report("#{resource}: new") { TIMES.times { route_map.recognize("#{resource}s/new") } }
    x.report("#{resource}: edit") { TIMES.times { route_map.recognize("#{resource}s/edit") } }
    x.report("#{resource}: show") { TIMES.times { route_map.recognize("#{resource}s/1") } }
  end
end