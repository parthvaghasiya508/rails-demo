describe("List", function() {
  /* global List */
  describe("runDelayedSearch", function() {
    beforeEach( function(){
      spec.loadFixture('empty_people_search');
    });

    it('inserts contact html', function(){
      List.handleSearchRefresh( { count:1, search_html: "<div class='testing_insert_div'>hello</div>" } );
      expect($(".testing_insert_div").text()).toEqual("hello");
    });
  });
});
