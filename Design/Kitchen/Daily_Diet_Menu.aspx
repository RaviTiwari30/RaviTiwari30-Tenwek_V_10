<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="Daily_Diet_Menu.aspx.cs" Inherits="Design_Kitchen_Daily_Diet_Menu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 100;
            $('#<%=txtDescription.ClientID %>').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    e.preventDefault();
                }
            });
        });
        function chkval(btn) {
            if ($.trim($("#<%=txtTypeName.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Component Name');
                modelAlert('Please Enter Component Name');
                $("#<%=txtTypeName.ClientID %>").focus();
                return false;
            }
            var con = 1;
            var chkList = document.getElementById('<%= chkDay.ClientID %>');
            var chkListinputs = chkList.getElementsByTagName("input");
            for (var i = 0; i < chkListinputs.length; i++) {
                if (chkListinputs[i].checked) {
                    con += 1;
                }
            }
            if (con == "1") {
                $("#<%=lblmsg.ClientID %>").text('Please select atleast one Days');
                modelAlert('Please select atleast one Days');
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting....';
            if ($("#<%=btnSave.ClientID%>").is(':visible'))
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            else
                __doPostBack('ctl00$ContentPlaceHolder1$btnUpdate', '');
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" >
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Diet Menu Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" style="display:none"></asp:Label>

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Master</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Menu Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTypeName" runat="server" CssClass="requiredField" MaxLength="100"></asp:TextBox>&nbsp;
                            <asp:Label ID="lblID" runat="server" Visible="False"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IsActive
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="true" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">DeActive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Days
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:CheckBoxList ID="chkDay" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Mon" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Tue" Value="2" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Wed" Value="3" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Thu" Value="4" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Fri" Value="5" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Sat" Value="6" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Sun" Value="7" Selected="True"></asp:ListItem>
                        </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" CausesValidation="False" OnClick="btnSave_Click"
                Text="Save" OnClientClick="return chkval(this)" />&nbsp;&nbsp;<asp:Button ID="btnUpdate" CssClass="ItDoseButton" runat="server" CausesValidation="False"
                    OnClick="btnUpdate_Click" Text="Update" OnClientClick="return chkval(this)" />&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server"
                        CausesValidation="False" CssClass="ItDoseButton" OnClick="btnCancel_Click" Text="Cancel" />

        </div>
        <asp:Panel ID="pnlHide" Visible="false" runat="server">

            <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="Purchaseheader">Menu Type Detail</div>
                <div class="Content" style="text-align: center;">
                    <asp:Panel ID="pnlgrid" runat="server" ScrollBars="Auto" Height="350px">
                        <asp:GridView ID="grdDetail" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdDetail_SelectedIndexChanged">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Diet Menu Name" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>

                                <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Days" HeaderText=" Applicable on Days" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>

                                <asp:TemplateField HeaderText="Active">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                        <div style="display: none;">
                                            <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("DietMenuID")+"#"+Eval("Name")+"#"+Eval("Description")+"#"+Eval("IsActive")+"#"+Eval("Days") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" SelectText="Edit" ButtonType="Image" SelectImageUrl="~/Images/edit.png" HeaderText="Edit">

                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                </asp:CommandField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
