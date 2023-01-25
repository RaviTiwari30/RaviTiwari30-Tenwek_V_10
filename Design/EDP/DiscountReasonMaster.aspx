<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DiscountReasonMaster.aspx.cs"
    Inherits="Design_EDP_DiscountReasonMaster" MasterPageFile="~/DefaultHome.master"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#387C44';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(PONo) {
            window.open(PONo);
        }

        function RestrictDoubleEntry() {
            if ($.trim($("#<%=txtDiscountReason.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Discount Reason');
                $("#<%=txtDiscountReason.ClientID%>").focus();
                return false;
            }
          
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b> Discount & Refund Reason Master</b>
            <br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged"
                                RepeatDirection="Horizontal" ToolTip="Select New Or Edit To Update SubCategory Master">
                                <asp:ListItem Selected="True">NEW</asp:ListItem>
                                <asp:ListItem>EDIT</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <asp:MultiView ID="MultiView1" runat="server">
            <asp:View ID="View1" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Create Discount & Refund Reason
                    </div>

                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Type
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlType" runat="server" ToolTip="Select Type">
                                        <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                        <asp:ListItem Text="Refund" Value="Refund"></asp:ListItem>
                                        <asp:ListItem Text="WriteOff" Value="WriteOff"></asp:ListItem>
                                    </asp:DropDownList>                                  
                                </div>
                                <div class="col-md-5">
                                    <label class="pull-left">
                                        Discount & Refund Reason
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtDiscountReason" runat="server" Width="95%" MaxLength="250" ToolTip="Enter Discount Reason" CssClass="required"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                   <asp:Button ID="btnSave" Text="Save" CssClass="ItDoseButton" runat="server" OnClientClick="return RestrictDoubleEntry();"
                        OnClick="btnSave_Click" TabIndex="13" ToolTip="Click to Save" />
                                </div>
                            </div>                  
                        </div>
                        <div class="col-md-1"></div>
                    </div>
              

                </div>
               
            </asp:View>
            <asp:View ID="View2" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Edit Discount & Refund Reason
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                    </label>

                                </div>
                                <div class="col-md-5">
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Type
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlType2" runat="server" ToolTip="Select Type">
                                        <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                        <asp:ListItem Text="Refund" Value="Refund"></asp:ListItem>
                                          <asp:ListItem Text="WriteOff" Value="WriteOff"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" TabIndex="13"
                                        OnClick="btnSearch_Click1" ToolTip="Click To Search" />
                                </div>
                                <div class="col-md-5">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                    <table style="width: 100%; border-collapse: collapse; ">
                        <tr>
                            <td colspan="4" style="text-align: left">
                                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                                    <ContentTemplate>
                                        <div style="overflow:auto; height:380px;">
                                        <asp:GridView ID="grdSubCategory" runat="server" Width="100%" style="overflow:auto;" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                           OnSelectedIndexChanged="grdSubCategory_SelectedIndexChanged">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemTemplate>
                                                        <%#Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                                </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Type">
                                                    <ItemTemplate>
                                                      <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                </asp:TemplateField>

                                               <asp:TemplateField HeaderText="Discount Reason">
                                               <ItemTemplate>
                                               <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                               <asp:TextBox ID="txtDiscountReason" MaxLength="50" runat="server" Text='<%#Eval("DiscountReason") %>'></asp:TextBox>
                                               </ItemTemplate>
                                               <ItemStyle CssClass="GridViewLabItemStyle" />
                                               <HeaderStyle CssClass="GridViewHeaderStyle"/>
                                               </asp:TemplateField>
                                                                              
                                                <asp:TemplateField HeaderText="Active">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblActive" Visible="false" runat="server" Text='<%#Eval("Active") %>'></asp:Label><asp:RadioButtonList
                                                            ID="rbtnActive2" runat="server" RepeatDirection="Horizontal" Text='<%#Eval("Active") %>'>
                                                            <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                                                            <asp:ListItem Text="No" Value="No"></asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                                                </asp:TemplateField>
                                                <asp:CommandField ShowSelectButton="True" SelectText="Edit" ButtonType="Image" SelectImageUrl="~/Images/post.gif" HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                    <ItemStyle CssClass="GridViewLabItemStyle"  Width="50px"  HorizontalAlign="Center" />
                                                </asp:CommandField>
                                            </Columns>
                                        </asp:GridView>
                                            </div>
                                    </ContentTemplate>
                                </Ajax:UpdatePanel>
                                <Ajax:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                    <ProgressTemplate>
                                        <asp:Image ID="Image1" runat="server" Width="38px" Height="31px" ImageUrl="~/Images/25-1.gif"></asp:Image><br />
                                    </ProgressTemplate>
                                </Ajax:UpdateProgress>
                            </td>
                        </tr>
                    </table>

                </div>
            </asp:View>
        </asp:MultiView><br />
    </div>
</asp:Content>
