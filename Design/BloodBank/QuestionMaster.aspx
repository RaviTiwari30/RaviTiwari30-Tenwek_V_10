<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="QuestionMaster.aspx.cs" Inherits="Design_BloodBank_QuestionMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = '#C2D69B';
            element.style.cursor = 'pointer';
            element.style.textDecoration = 'underline';
        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;
            element.style.textDecoration = 'none';
        }
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtQuestion.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtQuestion.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Question Master</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Questions Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Question
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:TextBox ID="txtQuestion" runat="server" Height="53px" MaxLength="200"
                                TabIndex="1" TextMode="MultiLine" Width="566px" ToolTip="Enter Question"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqQuestion" runat="server" ControlToValidate="txtQuestion"
                                ErrorMessage="Question Required" ValidationGroup="v1"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" TabIndex="2">
                                <asp:ListItem Selected="True" Value="r">Radio</asp:ListItem>
                                <asp:ListItem Value="t">Text</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal" TabIndex="3">
                                <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkSelected" runat="server" TabIndex="4" />Is Selected
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" ValidationGroup="v1"
                                TabIndex="5" OnClientClick="if(Page_ClientValidate()){__doPostBack;this.disabled=true;}" UseSubmitBehavior="false" CssClass="ItDoseButton" />
                            <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" TabIndex="6"
                                Text="Update" ValidationGroup="v1" OnClientClick="if(Page_ClientValidate()){__doPostBack;this.disabled=true;}" UseSubmitBehavior="false" CssClass="ItDoseButton" />
                            <asp:Button ID="btnCancel" runat="server" OnClick="btncancel_Click" TabIndex="7"
                                Text="Cancel" CssClass="ItDoseButton" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdQuestions" runat="server" AutoGenerateColumns="False" Width="100%"
                AllowPaging="true" PageSize="10" CssClass="GridViewStyle" OnSelectedIndexChanged="grdQuestions_SelectedIndexChanged"
                OnPageIndexChanging="grdQuestions_PageIndexChanging" OnRowDataBound="grdQuestions_RowDataBound">
                <PagerTemplate>
                    <strong><b>Number of Pages: <%=grdQuestions.PageCount%></b></strong>&nbsp;&nbsp;
                    <asp:Button ID="btnFirst" runat="server" CommandName="Page" ToolTip=" Select First" CssClass="ItDoseButton"
                        CommandArgument="First" Text="<<" />
                    <asp:Button ID="btnPrev" runat="server" CommandName="Page" ToolTip="Select Prev" CssClass="ItDoseButton"
                        CommandArgument="Prev" Text="<" />
                    <asp:Button ID="btnNext" runat="server" CommandName="Page" ToolTip="Select Next" CssClass="ItDoseButton"
                        CommandArgument="Next" Text=">" />
                    <asp:Button ID="btnLast" runat="server" CommandName="Page" ToolTip="Select Last" CssClass="ItDoseButton"
                        CommandArgument="Last" Text=">>" />
                </PagerTemplate>
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" Visible="false">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Question" HeaderText="Question">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Type" HeaderText="Type">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="IsActive" Visible="false">
                        <ItemTemplate>
                            <div style="display: none;">
                                <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("ID")+"#"+Eval("Question")+"#"+Eval("Type")+"#"+Eval("IsActive")%>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>
                    <asp:CommandField ShowSelectButton="True" SelectText="Edit" HeaderText="Edit">
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
