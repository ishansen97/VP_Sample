var dropDownList = function () {
  let dropDownListTemplate = `
  <div class="dropdown">
    <input 
      :disabled= "disabled" 
      ref="dropdowninput" 
      v-model.trim="inputValue"
      class="dropdown-input" 
      type="text"
      @focus="onSearchFocus"
      @blur="searchFocus = false"
      :placeholder="placeholder" />
    <div v-show="dropDownShow" @mouseover="dropDownFocus = true" @mouseleave="dropDownFocus = false" class="dropdown-list">
      <table v-if="itemList.length > 0 && !noData" class="categoryTable common_data_grid" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
          <tr class="categoryHeaderRow">
            <th v-if="showId" width="60px">Id</th>
            <th>Name</th>
          </tr>
          <tr @click="selectItem(item)" v-show="itemVisible(item)"  v-for="item in itemList" :key="item.dropDownList.id" class="1_contentTableRow dropdown-item">
            <td v-if="showId" class="cpp_idTableColumn">{{item.dropDownList.id}}</td>
            <td class="cpp_nameTableColumn">{{item.dropDownList.name}}</td>
          </tr>
        </tbody>
      </table>
      <table class="categoryTable common_data_grid" cellpadding="0" cellspacing="0" width="100%" v-else>
        <tbody>
          <tr class="1_contentTableRow dropdown-item">
            <th class="cpp_nameTableColumn"></th>
          </tr>
          <tr class="1_contentTableRow dropdown-item">
            <td class="cpp_nameTableColumn">No Records Found</td>
          </tr>
        </tbody>
        
      </table>
    </div>
  </div>
  `;

  Vue.component("drop-down-list", {
    template: dropDownListTemplate,
    data () {
      return {
        showId: this.showIdProp,
        defaultSelectId: this.defaultSelectIdProp,
        defaultSelectOnLoad: false,
        selectedItem: {},
        inputValue: '',
        searchFocus: false,
        dropDownFocus: false,
        itemList: [],
        placeholder: "Search",
        noData: false
      };
    },
    props: {
      listProp:{
        required: true,
        type: Array
      },
      placeholderProp:{
        type: String
      },
      disabled:{
        type: Boolean
      },
      showIdProp:{
        type: Boolean
      },
      defaultSelectIdProp:{
        type: Boolean
      },
      selectFunc:{
        required:true,
        type: Function
      },
      resetFunc:{
        required:true,
        type: Function
      },
      resetProp:{
        type: Boolean
      }
    },
    watch:{
      listProp: {
        immediate: true,
        handler() {
          this.itemList = this.listProp;
          if(!this.defaultSelectOnLoad && this.itemList.length > 0){
            this.selectDefault();
            this.defaultSelectOnLoad = true;
          }
        }
      },
      placeholderProp: {
        immediate: true,
        handler() {
          if(this.placeholderProp){
            this.placeholder = this.placeholderProp;
          }else{
            this.placeholder = "Search here";
          }
        }
      },
      resetProp: function(){
        if(this.resetProp){
          this.resetSelection();
        }
      },
      inputValue: function(){
        if(this.inputValue){
          var filtered =  this.itemList.filter(this.itemVisible)
          if(filtered.length == 0){
            this.noData = true;
            return;
          }
        }
        this.noData = false;
      }
    },
    computed: {
      dropDownShow: function() {
        if(this.searchFocus || this.dropDownFocus){
          return true;
        } else {
          this.updateInputValue();
          return false;
        }
      }
    },
    methods: {
      updateInputValue(){
        if(this.selectedItem.dropDownList?.id > 0){
          this.inputValue = (this.showId ? this.selectedItem.dropDownList.id + " - " :"") 
          + this.selectedItem.dropDownList.name;
        } else {
          this.inputValue = "";
        }
      },
      selectDefault(){
        if(this.defaultSelectId > 0){
          for (let i = 0; i < this.itemList.length; i++) {
            var ele = this.itemList[i];
            if(ele.dropDownList.id == this.defaultSelectId){
              this.selectItem(ele);
              break;
            }
          }
        }
      },
      onSearchFocus(){
        this.inputValue = '';
        this.searchFocus = true;
      },
      resetSelection () {
        this.selectedItem = {};
        this.resetFunc();
      },
      selectItem (item) {
        this.resetFunc();
        this.selectedItem = item;
        this.searchFocus = false;
        this.dropDownFocus = false;
        this.selectFunc(item);
      },
      itemVisible (item) {
        if(this.inputValue){
          let currentName = (`${item.dropDownList.id} ${item.dropDownList.name}`).toLowerCase();
          let currentInput = this.inputValue.toLowerCase();
          return currentName.includes(currentInput);
        } else {
          return true;
        }
      }
    }
  });
};



