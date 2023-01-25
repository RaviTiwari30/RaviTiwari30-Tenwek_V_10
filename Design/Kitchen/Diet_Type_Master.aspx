<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Diet_Type_Master.aspx.cs" Inherits="Design_Kitchen_Diet_Type_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 100;
            $('#<%=txtDescription.ClientID %>').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    e.preventDefault();
                }
            });
        });
        function validate(btn) {
            if ($.trim($("#<%=txtTypeName.ClientID%>").val()) == "") {
                $("#<%=lblmsg.ClientID%>").text('Please Enter Diet Type Name');
                modelAlert('Please Enter Diet Type Name');
                $("#<%=txtTypeName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtMin.ClientID%>").val()) == "") {
                modelAlert('Please Enter Min Value');
                $("#<%=lblmsg.ClientID%>").text('Please Enter Min Value');
                $("#<%=txtMin.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtMax.ClientID%>").val()) == "") {
                modelAlert('Please Enter Max Value ');
                $("#<%=lblmsg.ClientID%>").text('Please Enter Max Value ');
                $("#<%=txtMax.ClientID%>").focus();
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
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Diet Type Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" style="display:none;"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Master</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTypeName" CssClass="requiredField" runat="server"  MaxLength="50"></asp:TextBox>
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
                        <div class="col-md-4">
                            <label class="pull-left">
                                No. Of Component 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            Min.
                            <asp:TextBox ID="txtMin" runat="server" Width="35px" Text="0" MaxLength="4"></asp:TextBox>
                            - Max.
                        <asp:TextBox ID="txtMax" runat="server" Width="35px" Text="0" MaxLength="4"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fEarn3" runat="server" TargetControlID="txtMin" FilterMode="ValidChars" FilterType="Numbers, Custom"></cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtMax" FilterMode="ValidChars" FilterType="Numbers, Custom"></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
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
                        <div class="col-md-3">
                            <label class="pull-left">
                               Diet Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblIsPanelApproved" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="true" Value="0">Normal</asp:ListItem>
                                <asp:ListItem Value="1">Private</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" CssClass="ItDoseButton" OnClientClick="return validate(this)" runat="server" Text="Save" OnClick="btnSave_Click" />&nbsp;
            <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" OnClientClick="return validate(this)" Text="Update" OnClick="btnUpdate_Click" />&nbsp;
            <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" CausesValidation="False" Text="Cancel"
                OnClick="btnCancel_Click" />

        </div>
        <asp:Panel ID="pnlHide" Visible="false" runat="server">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">Diet Type Detail</div>
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
                        <asp:BoundField DataField="Name" HeaderText="Diet Name" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:BoundField>

                        <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Min" HeaderText="Min.&nbsp;Range" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Max" HeaderText="Max.&nbsp;Range" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:BoundField>
                         <asp:TemplateField HeaderText="Diet Type">
                            <ItemTemplate>
                                <asp:Label ID="lblIsPanelApproved" runat="server" Text='<%#Eval("IsPanelApproved")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="Active">
                            <ItemTemplate>
                                <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                <div style="display: none;">
                                    <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("dietID")+"#"+Eval("Name")+"#"+Eval("Description")+"#"+Eval("IsActive")+"#"+Eval("Min")+"#"+Eval("Max")+"#"+Eval("IsPanelApproved")%>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        
                        <asp:CommandField ShowSelectButton="True" ButtonType="Image" SelectImageUrl="~/Images/edit.png" SelectText="Edit" HeaderText="Edit">

                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                        </asp:CommandField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    </div>

</asp:Content>
