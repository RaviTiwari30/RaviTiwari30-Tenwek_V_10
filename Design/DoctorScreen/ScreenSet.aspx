<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="ScreenSet.aspx.cs" Inherits="Design_FrontOffice_ScreenMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server" >
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Display Screen</b><br />
             <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />                 
        </div>
        
        <div class="POuter_Box_Inventory">
            <Ajax:ScriptManager ID="sm" runat="server" /> 
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-24">
                            <div class="row">                     
                                <div class="col-md-3">                         
                                    Screen Name
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8"  style="text-align:left">
                                      <asp:DropDownList ID="ddlScreenName" CssClass="ItDoseDropDown requiredField"  TabIndex="1"  runat="server"></asp:DropDownList>
                                </div>                        
                                <div class="col-md-5">                          
                             <asp:Button ID="btnDisplay" runat="server" CssClass="ItDoseButton"  TabIndex="2" Text="Display" OnClick="btnDisplay_Click"/>
                                
                                </div>
                                <div class="col-md-8"  style="text-align:left"> 
                             
                                </div>
                                
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>

                 
         </div>
        </div>

</asp:Content>
