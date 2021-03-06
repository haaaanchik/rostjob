$(document).ready(function() {
  window.PITChatWidget = {
    init: function () {
      var self = this;
      var funcInit = function () {
        var funcMessageListener = function (event) {
          if (event && event.data && event.data.eventArgs) {
            if (event.data.eventArgs.type == 'close') {
              self.close();
            }
            else
            if (event.data.eventArgs.type == 'chatPageComplete') {
              PITChatWidget.DOM.makeChatVisible();
            }
          }
        };
        if (window.addEventListener) {
          window.addEventListener('message', funcMessageListener);
        } else {
          window.attachEvent('onmessage', funcMessageListener);
        }

        PITChatWidget.options.init(function () {
          PITChatWidget.Load.loadStyles();
          // PITChatWidget.DOM.drawButton();
          // PITChatWidget.DOM.buildChat();
          PITChatWidget.DOM.showChat();
        });
      };
      if (document.readyState === 'complete'
          || document.readyState === 'interactive') {
        funcInit();
      }
      else {
        window.addEventListener('load', function (event) {
          funcInit();
        });
      }
    },

    changeUser: function (userId, userName, userParams) {
      if (typeof userParams == 'undefined' || !userParams)
      {
        if ((!userId && PITChatWidget.options.userId == PITChatWidget.options.defaultUserId())
            || (userId == PITChatWidget.options.userId)) {
          return;
        }
        else {
          PITChatWidget.options.userId = userId;
          PITChatWidget.options.userName = userName ? userName : '';
          PITChatWidget.options.init(function () {
            PITChatWidget.DOM.updateChat();
          });
        }
      }
      else
      {
        if ((!userId && PITChatWidget.options.userId == PITChatWidget.options.defaultUserId())
            || (userId == PITChatWidget.options.userId)) {
        }
        else{
          PITChatWidget.options.userId = userId;
          PITChatWidget.options.userName = userName ? userName : '';
        }
        PITChatWidget.options.userParams = userParams;

        PITChatWidget.options.init(function () {
          PITChatWidget.DOM.updateChat();
        });

      }
    },

    close: function () {
      // PITChatWidget.DOM.hideChat();
      PITChatWidget.DOM.destroyChat();
    },

    destroy: function () {
      PITChatWidget.DOM.destroyButton();
      PITChatWidget.DOM.destroyChat();
    },

    trigger: function() {
      if (PITChatWidget.DOM.isChatOpen()) {
        PITChatWidget.DOM.hideChat();
        return false;
      }
      else {
        PITChatWidget.DOM.showChat();
        return true;
      }
    },

  };

  PITChatWidget.Utils = typeof PITChatWidget.Utils != 'undefined' && PITChatWidget.Utils ? PITChatWidget.Utils : {
    isUndefined: function (o) {
      return typeof o === 'undefined';
    },
    isString: function (o) {
      return typeof o === 'string';
    },
    newGuid: function () {
      function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
      }
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    },
    getCookie: function (name) {
      var matches = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"));
      return matches ? decodeURIComponent(matches[1]) : undefined;
    },
    setCookie: function (name, value) {
      document.cookie = name + "=" + value;
    },
    isAbsoluteUrl: function (url) {
      var r = new RegExp('^(?:[a-z]+:)?//', 'i');
      return r.test(url);
    },
    correctUrlToPit: function (pitUrl, url) {
      if (!url) {
        return '';
      }
      else if (this.isAbsoluteUrl(url)) {
        return url;
      }
      else {
        return pitUrl + url;
      }
    }

  };

  PITChatWidget.Load = typeof PITChatWidget.Load != 'undefined' && PITChatWidget.Load ? PITChatWidget.Load : {
    loadStyle: function (url) {
      if (url) {
        var link = document.createElement("link");
        link.href = url;
        link.type = "text/css";
        link.rel = "stylesheet";
        link.media = "screen,print";
        document.getElementsByTagName("head")[0].appendChild(link);
      }
    },
    loadStyles: function () {
      var self = this;
      this.loadStyle(PITChatWidget.Utils.correctUrlToPit(PITChatWidget.options.pitUrl, '/chat/pit-chat.css'));
      window.setTimeout(function () {
        self.loadStyle(PITChatWidget.Utils.correctUrlToPit(PITChatWidget.options.pitUrl, PITChatWidget.options.cssUrl));
      }, 10);
    }
  };

  PITChatWidget.DOM = typeof PITChatWidget.DOM != 'undefined' && PITChatWidget.DOM ? PITChatWidget.DOM : {
    drawButton: function () {
      var pitUrl = PITChatWidget.options.pitUrl;
      this.btn = document.createElement('img');
      this.btn.src = PITChatWidget.Utils.correctUrlToPit(pitUrl, PITChatWidget.options.openChatIcon);
      this.btn.dataset.state = "on";
      this.btn.dataset.on_src = PITChatWidget.Utils.correctUrlToPit(pitUrl, PITChatWidget.options.openChatIcon);
      this.btn.dataset.off_src = PITChatWidget.Utils.correctUrlToPit(pitUrl, PITChatWidget.options.closeChatIcon);
      this.btn.id = "pit-chat-btn";
      this.btn.className += " pit-chat-btn";
      var self = this;
      this.btn.addEventListener("click", function (ev) {
        if (self.isChatOpen()) {
          self.hideChat();
        }
        else {
          self.showChat();
        }
      });
      document.body.appendChild(this.btn);
    },

    isChatOpen: function () {
      return this.area && this.area.dataset.state == "on";
    },

    loadChatFrame: function () {
      var self = this;
      if (self.isChatOpen()) {
        var setFrameSrc = function () {
          if (self.frame.dataset.originalSrc != PITChatWidget.options.chatUrl) {
            self.frame.className += " pit-hidden";
            self.curtain.classList.remove("pit-hidden");
            self.frame.dataset.originalSrc = PITChatWidget.options.chatUrl;
            self.frame.src = PITChatWidget.options.chatUrl;
          }
        }
        if (!PITChatWidget.options.chatUrl) {
          PITChatWidget.options.getChatUrl(function () {
            setFrameSrc();
          });
        }
        else {
          setFrameSrc();
        }
      }
    },

    buildChat: function () {
      var self = this;
      var pitUrl = PITChatWidget.options.pitUrl;

      this.area = document.createElement('div');
      this.area.dataset.state = "off";
      this.area.id = "pit-chat-area";
      this.area.className += " pit-chat-area pit-hidden";
      document.getElementsByClassName('chat-body')[0].appendChild(this.area);

      this.header = document.createElement('div');
      this.header.className += " pit-chat-area-header";
      this.area.appendChild(this.header);

      if (PITChatWidget.options.сanChatAreaDragAndDrop) {
        this.header.className += " allow-move";
        this.header.addEventListener('mousedown', function (ev) {
          var body = document.body;
          var scrollTop = window.pageYOffset || body.scrollTop;
          var scrollLeft = window.pageXOffset || body.scrollLeft;
          var x0 = ev.offsetX, y0 = ev.offsetY;
          var parent = this.parentNode;
          //var box = parent.getBoundingClientRect();
          //var pX = box.left, pY = box.top;
          var oldOpacity = parent.style.opacity;
          parent.style.opacity = 0.85;
          var ifrm = document.getElementById("pit-chat-frame");
          ifrm.style['pointer-events'] = 'none';

          var moveChatArea = function (ev) {
            parent.style.left = (ev.pageX - x0 - scrollLeft) + "px";
            parent.style.top = (ev.pageY - y0 - scrollTop) + "px";
            ev.preventDefault();
            return false;
          };
          body.addEventListener("mousemove", moveChatArea, false);

          var endMoveChatArea = function (ev) {
            parent.style.opacity = oldOpacity;
            ifrm.style['pointer-events'] = 'auto';
            body.removeEventListener('mouseup', endMoveChatArea, false);
            body.removeEventListener('mousemove', moveChatArea, false);
            body.removeEventListener('mouseleave', endMoveChatArea, false);
            ev.preventDefault();
            return false;
          }
          body.addEventListener('mouseup', endMoveChatArea, false);
          body.addEventListener('mouseleave', endMoveChatArea, false);
          ev.preventDefault();
          return false;
        }, false);
      }

      var headerText = document.createElement('span');
      headerText.className += " pit-chat-area-header-text";
      this.header.appendChild(headerText);

      // var closeBtn = document.createElement('img');
      // closeBtn.src = PITChatWidget.Utils.correctUrlToPit(pitUrl, PITChatWidget.options.closeChatIcon);
      // closeBtn.className += " pit-chat-close-btn";
      // closeBtn.addEventListener("click", function (ev) {
      //   self.hideChat();
      // });
      // this.header.appendChild(closeBtn);

      this.curtain = document.createElement('div');
      this.curtain.className += " pit-chat-curtain";
      this.area.appendChild(this.curtain);

      this.frame = document.createElement('iframe');
      this.frame.id = "pit-chat-frame";
      this.frame.className += " pit-chat-frame pit-hidden";
      this.frame.frameBorder = 0;
      this.frame.dataset.originalSrc = "";
      this.frame.onload = function () { }
      this.loadChatFrame();
      this.area.appendChild(this.frame);

      window.setTimeout(function () {
        if (PITChatWidget.onBuildChatCompleted) {
          PITChatWidget.onBuildChatCompleted(self.area);
        }
        $('.pit-chat-curtain').text('Подождите пожалуйста.');
      }, 0);
    },

    updateChat: function () {
      if (!this.frame) {
        this.buildChat();
      }
      this.frame.src = this.frame.dataset.originalSrc = PITChatWidget.options.chatUrl = '';
      this.loadChatFrame();
    },

    showChat: function () {
      if (this.area) {
        this.area.classList.remove("pit-hidden");
        this.area.dataset.state = "on";
        // this.btn.dataset.state = "off";
        // this.btn.src = this.btn.dataset.off_src;
        this.loadChatFrame();
      }
      else {
        var self = this;
        PITChatWidget.options.init(function () {
          self.buildChat();
          window.setTimeout(function () {
            self.showChat();
          }, 100);
        });
      }
    },

    makeChatVisible: function () {
      this.curtain.className += " pit-hidden";
      this.frame.classList.remove("pit-hidden");
    },

    // hideChat: function () {
    //   if (this.area && this.btn) {
    //     this.area.className += " pit-hidden";
    //     this.area.dataset.state = "off";
    //     this.btn.dataset.state = "on";
    //     this.btn.src = this.btn.dataset.on_src;
    //   }
    // },

    destroyButton: function () {
      if (this.btn) {
        this.btn.remove();
        this.btn = null;
      }
    },

    destroyChat: function () {
      if (this.area) {
        this.area.remove();
        this.area = null;
        this.frame = null;
        PITChatWidget.options.chatUrl = null;
      }
    },
  };

  PITChatWidget.options = typeof PITChatWidget.options != 'undefined' && PITChatWidget.options ? PITChatWidget.options : {

    platformId: "B7002127-4D90-4567-97F5-A864821D2C07",
    channelId: "E3CEFC96-3946-40BA-9373-052FF0F75811",
    userId: null,
    userName: "",
    userParams: null,

    init: function (onSuccess) {
      this.getUserId();
      this.pitUrl = 'https://lk.vocamate.ru';
      this.entityId = document.getElementsByClassName('chat-body')[0].dataset.entityId;
      this.accountId = document.getElementsByClassName('chat-body')[0].dataset.accountId;

      this.userParams = {
        city: document.getElementsByClassName('chat-body')[0].dataset.city,
        vacancy: document.getElementsByClassName('chat-body')[0].dataset.utmCampaign,
        channelName: document.getElementsByClassName('chat-body')[0].dataset.channelName
      }
      this.getAccountSettings(onSuccess);
    },

    defaultUserId: function () {
      var uid = PITChatWidget.Utils.getCookie('pitChatUserId');
      if (!uid) {
        uid = PITChatWidget.Utils.newGuid();
        PITChatWidget.Utils.setCookie('pitChatUserId', uid);
      }
      return uid;
    },

    getUserId: function () {
      if (!this.userId) {
        this.userId = PITChatWidget.Utils.newGuid();
      }
      return this.userId;
    },

    buildData: function () {
      return {
        pitUrl: this.pitUrl,
        entityId: this.entityId,
        accountId: this.accountId,
        platformId: this.platformId,
        channelId: this.channelId,
        userId: this.userId,
        userName: this.userName,
        userParams: JSON.stringify(this.userParams)
      };
    },

    getAccountSettings: function (onSuccess) {
      var self = this;
      var data = this.buildData();
      var xhr = new XMLHttpRequest();
      xhr.open('POST', this.pitUrl + '/VI/Session/Chat/AccountRequest', true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.onreadystatechange = function () {
        if (this.readyState != 4) { return; }
        if (this.status != 200) { return; }
        if (this.responseText) {
          var respObj = JSON.parse(this.responseText);
          if (respObj.isEnabled) {
            self.cssUrl = respObj.cssUrl ? respObj.cssUrl : "/chat/chat.css"
            self.openChatIcon = respObj.openChatIcon ? respObj.openChatIcon : '/chat/chat_open.png';
            self.closeChatIcon = respObj.closeChatIcon ? respObj.closeChatIcon : '/chat/chat_close.png';
            self.сanChatAreaDragAndDrop = respObj.сanChatAreaDragAndDrop;
            if (onSuccess) {
              onSuccess();
            }
          }
          else {
            PITChatWidget.destroy();
          }
        }
      };
      xhr.send(JSON.stringify(data));
    },

    getChatUrl: function (onSuccess) {
      var self = this;
      var data = this.buildData();
      var xhr = new XMLHttpRequest();
      xhr.open('POST', this.pitUrl + '/VI/Session/Chat/UrlRequest', true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.onreadystatechange = function () {
        if (this.readyState != 4) { return; }
        if (this.status != 200) { return; }
        if (this.responseText) {
          var respObj = JSON.parse(this.responseText);
          if (respObj.isEnabled) {
            self.chatUrl = respObj.chatUrl;
            if (onSuccess) {
              onSuccess();
            }
          }
          else {
            PITChatWidget.destroy();
          }
        }
      };
      xhr.send(JSON.stringify({ requestBody: data }));
    }
  }
});