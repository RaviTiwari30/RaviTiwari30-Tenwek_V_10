<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wuc_AudioRecording.ascx.cs" Inherits="Design_Controls_wuc_AudioRecording" %>
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
 <script type="text/javascript">
     var a = document.querySelector('audio');
     function DHTMLSound(Path) {
         $("#audio").attr("src", Path);
         document.getElementById('audio').play();
     }
     

     //function pausePlay() {
     //    console.log('Will now try to pause video and play it again in same eventloop');

     //    a.pause();
     //    a.play();
     //}

     //window.onload = function () {
       

     //    setInterval(pausePlay, 1000);
  //   };
     </script>
<div class="POuter_Box_Inventory">
      <span id="dummyspan"></span>
    <audio controls src="" id="audio"></audio>
    <table style="width:100%;">
        <tr>
            <td style="width:42%;">
                <asp:LinkButton ID="btnRefresh" runat="server" Text="Refresh List" CssClass="ItDoseLinkButton" OnClick="btnRefresh_Click" Style="display: table-cell;" />
            </td>
            <td style="width:58%;">
                <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblType_SelectedIndexChanged" AutoPostBack="True">
                    <asp:ListItem Text="OPD" Selected="True" />
                    <asp:ListItem Text="IPD" />
                    <asp:ListItem Text="OPD LAB" />
                    <asp:ListItem Text="IPD LAB" />
                    <asp:ListItem Text="All" />
                </asp:RadioButtonList>
            </td>
        </tr>
    </table>
    <div class="Purchaseheader">
        <b>Today Audio Recording</b>
    </div>
    <asp:GridView ID="griddetail" runat="server" CssClass="GridViewStyle" OnRowCommand="griddetail_RowCommand" AutoGenerateColumns="False" OnRowDeleting="griddetail_RowDeleting">
        <Columns>
            <asp:TemplateField HeaderText="S.No.">
                <ItemTemplate>
                    <%# Container.DataItemIndex+1 %>
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Type">
                <ItemTemplate>
                    <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Date">
                <ItemTemplate>
                    <asp:Label ID="lblDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Time">
                <ItemTemplate>
                    <asp:Label ID="lblTime" runat="server" Text='<%#Eval("EntryTime") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Audio Name">
                <ItemTemplate>
                    <asp:Label ID="lblAudioName" runat="server" Text='<%#Eval("FileName") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="DeActivate">
                <ItemTemplate>
                    <asp:ImageButton ID="imgbtndelete" AlternateText="Delete" CommandName="Delete"
                        CommandArgument='<%#Eval("id")+"#"+Eval("UserID") %>' ImageUrl="~/Images/Delete.gif" runat="server" />
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Play">
                <ItemTemplate>
                    <asp:ImageButton ID="btnplay" AlternateText="Play" CommandName="Play" ToolTip="Play Recording"
                        CommandArgument='<%#Eval("id")+"#"+Eval("UserID")%>' ImageUrl="~/Images/play.jpg" runat="server" />
                 
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="AudioURL" Visible="false">
                <ItemTemplate>
                    <asp:Label ID="lblUrl" runat="server" Text='<%# Eval("Path") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader" style="text-align: left;">
            <b>Previous Audio Recording</b>
        </div>
        <asp:GridView ID="gridpredetail" runat="server" CssClass="GridViewStyle" OnRowCommand="gridpredetail_RowCommand" AutoGenerateColumns="False" OnRowDeleting="gridpredetail_RowDeleting">
            <Columns>
                <asp:TemplateField HeaderText="S.No.">
                    <ItemTemplate>
                        <%# Container.DataItemIndex+1 %>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date">
                    <ItemTemplate>
                        <asp:Label ID="lblDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Time">
                    <ItemTemplate>
                        <asp:Label ID="lblTime" runat="server" Text='<%#Eval("EntryTime") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Audio Name">
                    <ItemTemplate>
                        <asp:Label ID="lblAudioName" runat="server" Text='<%#Eval("FileName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="DeActivate">
                    <ItemTemplate>
                        <asp:ImageButton ID="imgbtndelete" AlternateText="Delete" CommandName="Delete"
                            CommandArgument='<%#Eval("id")+"#"+Eval("UserID") %>' ImageUrl="~/Images/Delete.gif" runat="server" />
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Play">
                    <ItemTemplate>
                        <asp:ImageButton ID="btnplay" AlternateText="Play" CommandName="Play" ToolTip="Play Recording"
                            CommandArgument='<%#Eval("id")+"#"+Eval("UserID") %>' ImageUrl="~/Images/play.jpg" runat="server" />
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="AudioURL" Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="lblUrl" runat="server" Text='<%# Eval("Path") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>
