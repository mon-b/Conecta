// Most of the code here comes from 
// https://medium.com/@valentinowong/using-rails-action-cable-with-a-vanilla-javascript-front-end-1e00ed90067e

const messagesListDiv = document.getElementById('messages-list');

// Renders a specific chat room when a user joins it
function renderChatRoom(chatRoomObject) {
    chatRoomObject.forEach( messageObject => {
        renderMessage(messageObject)
    })
}

// Renders a specific message
function renderMessage(messageObject) {
    const messageDiv = document.createElement('div')

    messageDiv.innerHTML = ``
    messageDiv.textContent = messageObject.username_raw +  ": " + messageObject.content;
    messageDiv.dataset.messageId = messageObject.id;

    // messagesListDiv.prepend(messageDiv);
    messagesListDiv.append(messageDiv); // correct order of messages. maybe because they are returned in id order ascending?
}

export { renderChatRoom, renderMessage };