#!/usr/bin/env ruby
#
# Check for changed posts

Jekyll::Hooks.register :posts, :post_init do |post|

  commit_num = `git rev-list --count HEAD "#{ post.path }"`

  if commit_num.to_i > 1
    lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`
    post.data['last_modified_at'] = lastmod_date
  end

end

# Hook for '_for-students' collection
Jekyll::Hooks.register :documents, :post_init do |doc|
  if doc.path.include?('_for-students')
    commit_num = `git rev-list --count HEAD "#{ doc.path }"`

    if commit_num.to_i > 1
      lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ doc.path }"`
      doc.data['last_modified_at'] = lastmod_date
    end
  end
end
