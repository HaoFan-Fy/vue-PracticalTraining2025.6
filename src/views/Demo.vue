<template>
  <div id="div">
    <el-divider>图片和头像组件</el-divider>
    <el-image style="width: 500px" src="http://huishao.cc/img/head-img.png">
      <template #placeholder>
        <h1>加载中...</h1>
      </template>
      <template #error>
        <h1>加载失败</h1>
      </template>
    </el-image>
    <div id="div">
      <!-- 使用文本类型的头像 -->
      <el-avatar style="margin: 20px">用户</el-avatar>
      <!-- 使用图标类型的头像 -->
      <el-avatar style="margin: 20px" icon="User"></el-avatar>
      <!-- 使用图片类型的头像 -->
      <el-avatar
        style="margin: 20px"
        :size="100"
        src="http://huishao.cc/img/avatar.jpg"
      ></el-avatar>
      <el-avatar
        style="margin: 20px"
        src="http://huishao.cc/img/avatar.jpg"
      ></el-avatar>
      <el-avatar
        style="margin: 20px"
        shape="square"
        src="http://huishao.cc/img/avatar.jpg"
      ></el-avatar>
    </div>
    <!-- 骨架屏组件 -->
    <el-divider>骨架屏组件</el-divider>
    <el-divider content-position="left">1</el-divider>
    <div id="div" style="text-align: left">
      <el-skeleton :animated="true">
        <template #template>
          <!-- 定义标题骨架 -->
          <el-skeleton-item
            variant="h1"
            style="width: 100px; height: 30px; padding: 0"
          />
          <!-- 定义图片骨架 -->
          <el-skeleton-item
            variant="image"
            style="width: 240px; height: 240px; padding: 0"
          />
          <!-- 定义段落骨架 -->
          <el-skeleton-item
            variant="p"
            style="width: 30%; padding: 0; margin-top: 20px"
          />
          <el-skeleton-item variant="p" style="width: 90%; padding: 0" />
          <el-skeleton-item variant="p" style="width: 90%; padding: 0" />
        </template>
      </el-skeleton>
    </div>

    <!-- 骨架屏组件 -->
    <el-divider content-position="left">2</el-divider>
    <div id="div" style="text-align: left">
      <el-skeleton :rows="5" :animated="true" :loading="loading">
        <h1>这里是真实的页面元素</h1>
        <p>{{ msg }}</p>
      </el-skeleton>
    </div>

    <!-- 空态图以及加载占位图组件 -->
    <el-divider>空态图以及加载占位图组件</el-divider>
    <div id="div">
      <el-empty description="设置空态图的描述文案" :image-size="100"></el-empty>
      <el-empty>
        <!-- image具名插槽用来替换默认的图片部分 -->
        <template v-slot:image>
          <div>这里是自定义图片位置</div>
        </template>
        <!-- description具名插槽用来替换默认的描述部分 -->
        <template v-slot:description>
          <h3>自定义描述内容</h3>
        </template>
        <!-- 默认的插槽用来在空态图的尾部追加内容 -->
        <el-button>看看其他内容</el-button>
      </el-empty>
    </div>

    <!-- 标签案例 -->
    <el-divider content-position="left"
      ><el-icon><star-filled /></el-icon
    ></el-divider>
    <div class="elTag">
      <el-tag>普通标签</el-tag>
      <span style="margin: 10px"></span>
      <el-tag :hit="true">描边标签</el-tag>
      <span style="margin: 10px"></span>
      <el-tag color="purple">紫色背景标签</el-tag>
    </div>

    <el-divider>动态标签</el-divider>
    <div id="div">
      <template v-for="(tag, index) in tags" :key="tag">
        <el-tag :closable="true" @close="closeTag(index)">{{ tag }}</el-tag>
        <span style="padding: 10px"></span>
      </template>
      <el-input
        style="width: 90px"
        v-if="show"
        v-model="inputValue"
        @keyup.enter="handleInputConfirm"
        @blur="handleInputConfirm"
        size="small"
      >
      </el-input>
      <el-button size="small" v-else @click="showInput">新建标签 +</el-button>
    </div>
    <el-divider>选中控制标签</el-divider>
    <div id="div">
      <el-check-tag :checked="true">足球</el-check-tag>
      <span style="padding: 10px"></span>
      <el-check-tag :checked="false">篮球</el-check-tag>
    </div>
    <!-- 分割线 -->
    <el-divider content-position="left">按钮案例</el-divider>
    <!-- 按钮案例 -->
    <div class="btnArea">
      <!-- 按钮尺寸 -->
      <el-button>默认按钮</el-button>
      <el-button size="medium">中等按钮</el-button>
      <el-button size="small">小型按钮</el-button>
      <el-button size="mini">超小按钮</el-button>
    </div>
    <div class="btnArea">
      <!-- 按钮类型 -->
      <el-button type="primary">常规按钮</el-button>
      <el-button type="success">成功按钮</el-button>
      <el-button type="info">信息按钮</el-button>
      <el-button type="warning">警告按钮</el-button>
      <el-button type="danger">危险按钮</el-button>
    </div>
    <div class="btnArea">
      <!-- 按钮外形控制 -->
      <el-button type="primary" :plain="true">描边</el-button>
      <el-button type="primary" :round="true">圆角</el-button>
      <el-button type="primary" :circle="true">圆形</el-button>
      <el-button type="primary" :disable="true">禁用</el-button>
      <el-button type="primary" :loading="true">加载</el-button>
    </div>
    <div class="btnArea">
      <!-- 图标 -->
      <el-button type="primary" icon="Share"></el-button>
      <el-button type="primary" icon="Delete"></el-button>
      <el-button type="primary" icon="Search">图标在前</el-button>
      <el-button type="primary"
        >图标在后<i class="el-icon-upload el-icon--right"></i
      ></el-button>
      <el-button type="primary"
        >图标在后<el-icon style="margin-left: 8px"><Upload /></el-icon>
      </el-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tags: ["男装", "女装", "帽子", "鞋子"],
      show: false,
      inputValue: "",
      // 控制骨架屏
      loading: true,
      msg: "",
    };
  },
  mounted() {
    setTimeout(this.getData, 5000);
  },
  methods: {
    getData() {
      this.msg = "这是请求来的数据";
      this.loading = false;
    },
    closeTag(index) {
      this.tags.splice(index, 1);
    },
    showInput() {
      this.show = true;
    },
    handleInputConfirm() {
      let inputValue = this.inputValue;
      if (inputValue) {
        this.tags.push(inputValue);
      }
      this.show = false;
      this.inputValue = "";
    },
  },
};
</script>

<style scoped>
.btnArea > * {
  margin-top: 10px;
}
</style>
