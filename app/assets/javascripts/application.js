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
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){

    // posts to /games/:id/moves to create a new move
    //   which will redirect/reload this page
    $('.column-button').click(function(){
        var column = $(this).attr('column');
        var animatedCell = $('.cell.animated.column'+column);
        var player = $('#turn').attr('player');

        if(animatedCell.is(":visible") ){
            $('.column-button').hide();

            $.post($('#post_moves_path').attr('path'),
                { player: player, column: column },
                function() {
                    isWinner();
                }
            ).complete(function () {
                    drop_cell(animatedCell, column, player);
                    setNewPlayer();
                    $('.column-button').show();
                });

            // form submission. change to ajax request
    //        $('#move_column').val(column);
    //        $('#move_form').submit();
        }
    });

    $('.column-button').hover(
        function(){
            $(this).next('.cell.animated').show();
        },
        function(){
            if($(this).is(':visible')){
                $(this).next('.cell.animated').hide();
            }
        }
    );

    function isWinner(){

    }

    function setNewPlayer() {
        var player = $('#turn').attr('player');
        var newPlayer = (player == 'blue') ? 'red' : 'blue';
        $('#turn').attr('player', newPlayer);
        $('.animated.cell').removeClass(player).addClass(newPlayer)
    }

    function drop_cell(cell, column, player) {
        var move_length = (6 - $('.column'+column+'.cell-wrapper').children().length)*100;
        cell.animate({top: move_length}, '500',
            function(){
                $('.column'+column+'.cell-wrapper').prepend('<div class="cell '+player+'"><div>');
                cell.hide();
                cell.css('top', 0);
            }
        );
    }
});