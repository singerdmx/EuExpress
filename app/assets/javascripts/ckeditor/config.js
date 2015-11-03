/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function (config) {
    // Define changes to default configuration here. For example:
    config.language = 'en';
    config.uiColor = '#f5f5f5';
    config.toolbar = [
        {name: 'document', items: ['Source', '-', 'NewPage', 'Preview', 'Print', '-', 'Templates']},
        {name: 'clipboard', items: ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo']},
        {name: 'editing', items: ['Find', 'Replace', '-', 'SelectAll', '-', 'Scayt']},
        {
            name: 'forms',
            items: ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField']
        },
        '/',
        {
            name: 'basicstyles',
            items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']
        },
        {
            name: 'paragraph',
            items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl']
        },
        {name: 'links', items: ['Link', 'Unlink', 'Anchor']},
        {
            name: 'insert',
            items: ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak']
        },
        '/',
        {name: 'styles', items: ['Styles', 'Format', 'Font', 'FontSize']},
        {name: 'colors', items: ['TextColor', 'BGColor']},
        {name: 'tools', items: ['Maximize', 'ShowBlocks']},
    ];
    config.smiley_descriptions =
        [
            'smiley', 'sad', 'wink', 'laugh', 'frown', 'cheeky', 'blush', 'surprise',
            'indecision', 'angry', 'angel', 'cool', 'devil', 'crying', 'wild_smile', 'cool_guy', 'sweat',
            'despise_you', '5.gif', '6.gif', '7.gif', '8.gif', '9.gif', '10.gif', '03.gif',
            'enlightened', 'no',
            'yes', 'heart', 'broken heart', 'kiss', 'mail',
        ];
    config.smiley_images = [
        'regular_smile.gif', 'sad_smile.gif', 'wink_smile.gif', 'teeth_smile.gif', 'confused_smile.gif', 'tounge_smile.gif',
        'embaressed_smile.gif', 'omg_smile.gif', 'whatchutalkingabout_smile.gif', 'angry_smile.gif', 'angel_smile.gif', 'shades_smile.gif',
        'devil_smile.gif', 'cry_smile.gif', 'wild_smile.gif', 'cool_guy.gif', 'sweat.gif', 'despise_you.gif',
        '5.gif', '6.gif', '7.gif', '8.gif', '9.gif', '10.gif', '03.gif',
        'lightbulb.gif', 'thumbs_down.gif', 'thumbs_up.gif', 'heart.gif',
        'broken_heart.gif', 'kiss.gif', 'envelope.gif'];
};
