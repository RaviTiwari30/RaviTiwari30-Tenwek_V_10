<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Set_Default_Diet.aspx.cs" Inherits="Design_Kitchen_Set_Default_Diet" EnableViewState="true" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
                   });
        function validate(id)
        {
            if ($('#<%=ddlDietType.ClientID %>').val() == '--Select--')
            {
                $('#<%=lblmsg.ClientID %>').html("Select Diet Type.");
                $('#<%=lblmsg.ClientID %>').show();
                return false;
            }

            if ($('#<%=ddlSubDietType.ClientID %>').val() == '--Select--') {
                $('#<%=lblmsg.ClientID %>').html("Select Sub Diet Type.");
                 $('#<%=lblmsg.ClientID %>').show();
                 return false;
             }
        }

        function validateMenu(id) {
            if ($('#<%=ddlMenu.ClientID %>').val() == '--Select--') {
                $('#<%=lblmsg.ClientID %>').html("Select Menu .");
                $('#<%=lblmsg.ClientID %>').show();
                return false;
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Default Diet<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" style="display:none;"></asp:Label>
        </div>      
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Set Default Diet & SubDiet</div>
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
                            <asp:RadioButtonList ID="rblIsPanelApproved" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rblIsPanelApproved_SelectedIndexChanged">
                                <asp:ListItem Value="0" Selected="True"> Normal </asp:ListItem>
                                <asp:ListItem Value="1"> Private </asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDietType" runat="server" TabIndex="2" AutoPostBack="true" OnSelectedIndexChanged="ddlDietType_SelectedIndexChanged"
                                ToolTip="Select Diet Type">
                            </asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Sub Diet Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlSubDietType" runat="server" TabIndex="2" AutoPostBack="false"
                                 ToolTip="Select Sub Diet Type">
                             </asp:DropDownList>
                         </div>                        
                    </div>                   
                </div>
            </div>           
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">            
             <asp:Button ID="btnSave" CssClass="ItDoseButton" OnClientClick="return validate(this)" runat="server" Text="Save" OnClick="btnSave_Click" />             
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">                
                <asp:GridView ID="grdDietType" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdDietType_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%#Eval("DType")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="DietType">
                            <ItemTemplate>
                                <asp:Label ID="lblNAME" runat="server" Text='<%#Eval("NAME")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub DietType">
                            <ItemTemplate>
                                <asp:Label ID="lblSubDiet" runat="server" Text='<%#Eval("SubDiet")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>                       
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblCreatedBy" runat="server" Text='<%#Eval("EntryBy")%>'></asp:Label>                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>                        
                        <asp:TemplateField HeaderText="Entry DateTime">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDateTime" runat="server" Text='<%#Eval("EntryDateTime")%>'></asp:Label>
                                <asp:Label ID="lblDietID" runat="server" Visible="false" Text='<%#Eval("DietId")%>'></asp:Label>  
                                <asp:Label ID="lblSubDietID" runat="server" Visible="false" Text='<%#Eval("SubDietID")%>'></asp:Label>                              
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

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Menu Detail</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Menu
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMenu" runat="server" TabIndex="2" AutoPostBack="false"
                                ToolTip="Select Menu">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-5">
                            <asp:Button ID="btnSaveMenu" CssClass="ItDoseButton" OnClientClick="return validateMenu(this)" runat="server" Text="Save" OnClick="btnSaveMenu_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">               
                <asp:GridView ID="grdMenuDetails" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdMenuDetails_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="lblNAME" runat="server" Text='<%#Eval("NAME")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblCreatedBy" runat="server" Text='<%#Eval("EntryBy")%>'></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry DateTime">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDateTime" runat="server" Text='<%#Eval("EntryDateTime")%>'></asp:Label>
                                
                                <asp:Label ID="lblDietMenuID" runat="server" Visible="false" Text='<%#Eval("DietMenuID")%>'></asp:Label>
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
   
    </div>

</asp:Content>
