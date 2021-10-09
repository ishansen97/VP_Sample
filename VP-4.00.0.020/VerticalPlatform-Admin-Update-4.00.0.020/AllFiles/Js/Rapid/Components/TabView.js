var tabView = function () {
  let tabsTemplate = `
  <div class="page-content-area">
    <div class="tabs-container">
      <div class="menuHorizontal">
      <ul class="menu">
        <li v-for="tab in tabs" class="btn" :class="{ 'selected': tab.isActive }">
          <a :href="tab.href" @click="selectTab(tab)">{{ tab.name }}</a>
        </li>
      </ul>
      </div>
    </div>

    <div class="tabs-details">
      <slot></slot>
    </div>
  </div>
`;

  Vue.component('tabs', {
    template: tabsTemplate,
    data() {
      return { tabs: [] };
    },
    created() {
      this.tabs = this.$children;
    },
    methods: {
      selectTab(selectedTab) {
        this.tabs.forEach(tab => {
          tab.isActive = (tab.name === selectedTab.name);
        });
      }
    }
  });

  let tabTemplate = `
  <div v-show="isActive"><slot></slot></div>
  `;

  Vue.component('tab', {
    template: tabTemplate,
    props: {
      name: { required: true },
      selected: { default: false }
    },
    data() {
      return {
        isActive: false
      };
    },
    mounted() {
      this.isActive = this.selected;
    }
  });
};