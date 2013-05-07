$(function () {
    $('#homepage').find('#user_email').popover({
        html : true,
        title: "Please Use a .edu Address If Possible",
        placement: 'left',
        trigger: 'focus',
        content: "<p>This will help us verify that you are qualified to post on Journal Lab.</p><p>If you do not have a .edu address and are published in a peer-reviewed journal you will still be able to post. We'll verify you later.</p>"
    });
    $('#registrationPage').find('#user_email').popover({
        html : true,
        title: "Please Use a .edu Address If Possible",
        placement: 'right',
        trigger: 'focus',
        content: "<p>This will help us verify that you are qualified to post on Journal Lab.</p><p>If you do not have a .edu address and are published in a peer-reviewed journal you will still be able to post. We'll verify you later.</p>"
    });
    $('#follow_search_term').popover({
        html : true,
        title: "Enter Multiple Feeds At Once!",
        placement: 'right',
        trigger: 'focus',
        content: "<p>Separate multiple feeds with commas:</p>" +
            "<p><em>DNA, RNA, Microrna</em></p>"
    });
    $('#userStatus').popover({
        html : true,
        title: "Are You Part of the Research Community?",
        placement: 'right',
        trigger: 'focus',
        content: "<p>You must be a practicing researcher or clinician to post on Journal Lab.</p>" +
            "<p>If you are a practicing researcher who is not pursuing a PhD, please <a href='mailto:david@journallab.org'>email us</a>.</p>" +
            "<p>If you are not a practicing researcher or clinician you are still welcome to use Journal Lab to track the latest research and discussion!</p>"
    });

        $('#user_position').typeahead({
        name: 'positions',
        source: ["Faculty","Grad Student","Post-Doc","Principal Investigator", "Help, I'm trapped in a PhD!"]
        });
});