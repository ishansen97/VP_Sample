var pageList = function () {
  let template = `
  <div>
    <nav>
      <div class="pagination">
        <div class="page-item">
          <button type="button" :disabled="page == 1" class="page-link btn no-outline" @click="page = 1"><img src="../../Js/Rapid/Assets/Images/chevrons-left.svg"></button>
          <button type="button" :disabled="page == 1" class="page-link btn no-outline" @click="page--"><img src="../../Js/Rapid/Assets/Images/chevron-left.svg"></button>
        </div>
        <div class="page-item">
          <button type="button"
          class="page-link btn no-outline" 
          :class="page == pageNumber ? 'active':''"
          v-for="pageNumber in pagesDisplay" 
          @click="page = pageNumber"> {{pageNumber}} </button>
        </div>
        <div class="page-item">
          <button type="button" @click="page++" :disabled="page >= pages.length" class="page-link btn no-outline"><img src="../../Js/Rapid/Assets/Images/chevron-right.svg"></button>
          <button type="button" @click="page = pages.length" :disabled="page >= pages.length" class="page-link btn no-outline"><img src="../../Js/Rapid/Assets/Images/chevrons-right.svg"></button>
        </div>
      </div>
    </nav>
  </div>
`;

  Vue.component('page-list', {
    template: template,
    mixins: [_jobApiMixin],
    props: {
      totalCountProp:{
        required: true,
        type: Number
      },
      pageLimitProp:{
        required: true,
        type: Number
      },
      paginateFunc:{
        required:true,
        type: Function
      },
      resetProp:{
        type: Boolean
      },
      resetCompleteCallBack:{
        type: Function
      }
    },
    data() {
      return {
        page: 1,
        pageLimit: this.pageLimitProp,
        pages: [],
        totalCount: this.totalCountProp
      };
    },
    watch:{
      totalCountProp: {
        immediate: true,
        handler() {
          this.totalCount = this.totalCountProp;
          this.setPages();
        }
      },

      async page(){
        let page = this.page;
        let pageLimit = this.pageLimit;
        let from = ((page - 1) * pageLimit) + 1;
        let to = page * pageLimit;
        await this.paginateFunc(from, to);
      },

      resetProp() {
        if(this.resetProp){
          this.page = 1;
          this.resetCompleteCallBack()
        }
      }
    },
    methods: {
      setPages() {
        this.pages = [];
        let numberOfPages = Math.ceil(this.totalCount / this.pageLimit);
        for (let index = 1; index <= numberOfPages; index++) {
          this.pages.push(index);
        }
      }
    },
    computed:{
      pagesDisplay(){
        var pagesStart = 0;
        var pagesEnd = 10;
        if(this.page > 5){
          pagesStart = this.page-5;
          pagesEnd = this.page+5;
        }
        return this.pages.slice(pagesStart, pagesEnd)
      }
    }
  });
};