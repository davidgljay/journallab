$(function () {
    $('#user_email').popover({
        html : true,
        title: "Please Use a .edu Address If Possible",
        placement: 'left',
        trigger: 'focus',
        content: "<p>This will help us verify that you are qualified to post on Journal Lab.</p><p>If you do not have a .edu address and are published in a peer-reviewed journal you will still be able to post. We'll verify you later.</p>"
    });
});