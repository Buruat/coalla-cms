// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require admin/jquery-migrate.min
//= require jquery-ui
//= require jquery-ui-timepicker-addon
//= require admin/vendor/jquery-ui-timepicker-addon-ru
//= require jquery_ujs
//= require admin/vendor/bootstrap.min
//= require jquery.remotipart
//= require admin/vendor/jquery.tokeninput.patched
//= require admin/vendor/jquery.tagsinput
//= require admin/vendor/underscore-min
//= require js-routes
//= require ckeditor/init
//= require admin/photo_uploader
//= require_self
//= require admin/custom_admin

var CMS = CMS || {};
CMS.config = CMS.config || {};
CMS.config.language = CMS.config.language || 'ru';

function injectNewSliderId(s, id) {
    return s.replace(/NEW_RECORD/g, id);
}

(function ($) {
    $.fn.stickyBar = function () {
        if (this.length) {
            var $bar = this,
                barOffsetTop = $bar.offset().top,
                barOuterHeight = $bar.outerHeight(),
                windowScrollTop = $(window).scrollTop(),
                windowHeight = $(window).height();

            if (barOffsetTop + barOuterHeight > windowScrollTop + windowHeight) {
                $bar.addClass('__sticky');
            }

            $(window).scroll(function () {
                windowScrollTop = $(window).scrollTop();
                windowHeight = $(window).height();

                if (barOffsetTop + barOuterHeight > windowScrollTop + windowHeight) {
                    $bar.addClass('__sticky');
                } else {
                    $bar.removeClass('__sticky');
                }
            });
        }
    }

})(jQuery);

$(function () {
    $(document).on('click', '.pictograms__button_remove', function () {
        var
            $this = $(this),
            container = '.' + $this.data('container');
        var input = $this.prev(':hidden');
        if (input.size() > 0) {
            $(input[0]).attr("value", "1");
            $this.closest(container).hide();
        } else {
            $(this).closest(container).remove();
        }
        return false;
    });

    $(document).on('click', '[data-image-remove-btn]', function () {
        var container = $(this).closest('.upload-img-container');
        container.find('[data-image-preview]').hide();
        container.find('[data-image-placeholder]').show();
        container.find('[data-image-remove-flag]').val(1);
        return false;
    });

    $('.sortable').sortable();

    function merge_datepicker_options($element) {
        var options = {
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true
        };
        var customOptions = $element.data('calendar-options');
        if (customOptions) {
            options = $.extend(options, customOptions);
        }
        return options;
    }

    function addDatePickers() {
        $('input[data-calendar-date]').each(function () {
            var $this = $(this);
            $this.datepicker(merge_datepicker_options($this));
        });
    }

    CMS.addDatePickers = addDatePickers;

    addDatePickers();

    function addDateTimePickers() {
        $('input[data-calendar-datetime]').each(function () {
            var $this = $(this);
            $this.datetimepicker(merge_datepicker_options($this));
        });
    }

    CMS.addDateTimePickers = addDateTimePickers;

    addDateTimePickers();

    function addTimePickers() {
        $('input[data-calendar-time]').each(function () {
            var $this = $(this);
            $this.timepicker(merge_datepicker_options($this));
        });
    }

    CMS.addTimePickers = addTimePickers;

    addTimePickers();

    function addMultiField($container) {
        var $el;

        if ($container) {
            $el = $container.find('[data-multi-field]');
        } else {
            $el = $('[data-multi-field]');
        }

        $el.each(function () {
            var options = {
                crossDomain: false,
                preventDuplicates: true,
                theme: 'bootstrap',
                showAllOnFocus: $(this).data('show-all-on-focus'),
                useCache: $(this).data('use-cache')
            };

            if (CMS.config.language == 'ru') {
                options.hintText = 'Введите строку для поиска';
                options.noResultsText = 'Ничего не найдено';
                options.searchingText = 'Поиск...';
            }

            var objectUrlName = $(this).data('object-url-name');
            if (objectUrlName) {
                var formatter_options = {
                    tokenFormatter: function (item) {
                        return "<li><p><a href='" + "/admin/" + objectUrlName + "/" + item['id'] + "/edit'>" + item[this.propertyToSearch] + "</a></p></li>"
                    }
                };
                options = $.extend(options, formatter_options);
            }

            $(this).tokenInput($(this).data('source'), options);
        });
    }

    CMS.addMultiField = addMultiField;

    addMultiField();

    $(document).on('click', '.close-popover-form', function () {
        $('.pictograms__button_edit').popover('hide');
        $('.popover').css('display', 'none');
    });

    $(document).on('click', '.submit-popover-form', function () {
        var
            $title = $(this).closest('.slide-form-group').find('input[type="text"]');
        $('#' + $title.attr('id')).val($title.val());
        $('.pictograms__button_edit').popover('hide');
        $('.popover').css('display', 'none');
    });

    function updateArrowButtons($context) {
        $context = $context || $('body');

        $context.find('[data-sort-up]').each(function () {
            var $this = $(this),
                $prev = $this.closest('.fields_container').prevAll('.fields_container:not(:hidden)').first();

            if ($prev.length == 0) {
                $this.hide();
            } else {
                $this.show();
            }
        });

        $context.find('[data-sort-down]').each(function () {
            var $this = $(this),
                $next = $this.closest('.fields_container').nextAll('.fields_container:not(:hidden)').first();

            if ($next.length == 0) {
                $this.hide();
            } else {
                $this.show();
            }
        });

        $context.find('[data-sort-position]').each(function () {
            var $this = $(this),
                $prevAll = $this.closest('.fields_container').prevAll('.fields_container:not(:hidden)');

            $this.html($prevAll.length + 1);
        });
    }

    CMS.updateArrowButtons = updateArrowButtons;

    $(document).on('click', '[data-sort-up]', function () {
        var $current = $(this).closest('.fields_container'),
            $prev = $current.prevAll('.fields_container:not(:hidden)').first();


        $prev.before($current);
        $('html, body').animate({
            scrollTop: $current.offset().top - 50
        }, 300);
        updateArrowButtons($current.closest('[data-sortable-blocks]'));

        return false;
    });

    $(document).on('click', '[data-sort-down]', function () {
        var $current = $(this).closest('.fields_container'),
            $next = $current.nextAll('.fields_container:not(:hidden)').first();

        $next.after($current);
        $('html, body').animate({
            scrollTop: $current.offset().top - 50
        }, 300);
        updateArrowButtons($current.closest('[data-sortable-blocks]'));

        return false;
    });

    updateArrowButtons();

    var $form = $('form');
    $form.on('click', '.remove_field', function () {
        $(this).closest('.fields_container').find('input[name*="_destroy"]').val('1');
        $(this).closest('.fields_container').hide();
        updateArrowButtons($(this).closest('[data-sortable-blocks]'));
        return false;
    });

    CMS.addNestedFields = function ($el) {
        var time = new Date().getTime();
        var regexp = new RegExp($el.data('id'), 'g');
        var wrapper = $el.closest('.nested_buttons');
        var insertHtml = $($el.data('fields').replace(regexp, time));
        wrapper.before(insertHtml);
        // fix for Bootstrap 3 dropdown components
        wrapper.removeClass('open');
        window.NestedFormCallbacks = window.NestedFormCallbacks || [];
        _.each(window.NestedFormCallbacks, function (callback) {
            callback(insertHtml);
        });
        addDatePickers();
        addDateTimePickers();
        addTimePickers();
        addMultiField(insertHtml);
        updateArrowButtons(insertHtml.closest('[data-sortable-blocks]'));

        return insertHtml;
    };

    $form.on('click', '.add_fields', function () {
        CMS.addNestedFields($(this));
        return false
    });

    $('[data-sortable-blocks="true"]').sortable({
        items: '.fields_container',
        cancel: 'input,textarea,button,select,option,a',
        stop: function (e, ui) {
            var $context = $(e.target);
            updateArrowButtons($context);
        }
    });

    $(document).on('click', '[data-editable-column]', function () {
        var $this = $(this),
            url = $this.data('url');

        if ($this.data('editable-column-initialized')) {
            return;
        }

        $.get(url, $this.data(), function (response) {
            var $form = $(response.form);
            $this.data('previous-value', $this.html());
            $this.html($form);

            window.EditableColumnCallbacks = window.EditableColumnCallbacks || [];
            _.each(window.EditableColumnCallbacks, function (callback) {
                callback($form);
            });

            addDatePickers();
            addDateTimePickers();
            addTimePickers();
            addMultiField($form);

            $this.data('editable-column-initialized', true);
        }).error(function () {
            console.error('Unable to render edit form for column');
        });

        return false;
    });

    $(document).on('ajax:success', '[data-editable-column-form]', function (e, response) {
        var $editableColumn = $(this).closest('[data-editable-column]');

        $('.alert').closest('.row').remove();

        if (!response.alert) {
            $editableColumn.html(response.result);
            $editableColumn.data('previous-value', $editableColumn.html());
            $editableColumn.data('editable-column-initialized', false);
            return;
        }

        $editableColumn.closest('.table-responsive').before(response.alert)
        $editableColumn.html($editableColumn.data('previous-value'));
        $editableColumn.data('editable-column-initialized', false);
    });

    function cancelEditColumn($el) {
        var $editableColumn = $el.closest('[data-editable-column]');
        $editableColumn.html($editableColumn.data('previous-value'));
        $editableColumn.data('editable-column-initialized', false);
    }

    $(document).on('click', '[data-editable-column-cancel]', function () {
        cancelEditColumn($(this));

        return false;
    });

    $(document).on('ajax:error', '[data-editable-column-form]', function () {
        cancelEditColumn($(this));

        console.error('Unable to render edit form for column');
    });

    function showRemoteModal(url) {
        var $modal = $('body').find('#modal');

        $.get(url, function (response) {
            var $modalContent = $(response.modal);

            $modal.find('.modal-content').html($modalContent);
            $modal.modal('show');

            window.RemoteModalCallbacks = window.RemoteModalCallbacks || [];
            _.each(window.RemoteModalCallbacks, function (callback) {
                callback($modalContent);
            });

            addDatePickers();
            addDateTimePickers();
            addTimePickers();
            addMultiField($modalContent);

            return false;
        });
    };

    CMS.showRemoteModal = showRemoteModal;

    $(document).on('click', '[data-remote-modal]', function (e) {
        var $el = $(this);

        showRemoteModal($el.attr('href'));

        return false;
    });

    $('.action-bar').stickyBar();

    $(document).on('change', '[data-file-upload]', function () {
        var filename = $(this).val().replace(/.*(\/|\\)/, ''),
            container = $(this).closest('[data-file-upload-container]');

        container.find('[data-file-upload-title]').text(filename);

        if (filename.length > 0) {
            container.find('[data-file-remove-flag]').val(0);
        }
    });

    $(document).on('click', '[data-file-remove-btn]', function () {
        var container = $(this).closest('[data-file-upload-container]'),
            title = container.find('[data-file-upload-title]');
        title.text(title.data('label'));
        container.find('[data-file-upload]').val('');
        container.find('[data-file-remove-flag]').val(1);
        return false;
    });

    $('[data-toggle="tooltip"]').tooltip({'trigger': 'focus'});
});

CKEDITOR.config.extraPlugins = 'slideshow,mediaembed,autogrow';
CKEDITOR.config.removeButtons = 'About,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,BidiLtr,BidiRtl,Language,Scayt,Smiley,SpellChecker,Templates,Indent,CreateDiv,HorizontalRule,Flash,NewPage,PageBreak,Iframe,Styles,FontSize,Font,TextColor,BGColor,JustifyLeft,JustifyCenter,JustifyRight,JustifyBlock';
CKEDITOR.config.removePlugins = 'scayt,smiley';
CKEDITOR.config.language = CMS.config.language;