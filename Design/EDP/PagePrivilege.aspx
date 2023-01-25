<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PagePrivilege.aspx.cs" Inherits="Design_EDP_PagePrivilege" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <ajax:ScriptManager ID="sm" runat="server"></ajax:ScriptManager>
    <style type="text/css">
    .ui-tabs.ui-tabs-vertical {
        padding: 0;
        width: 85em;
        position: static;
    }

        .ui-tabs.ui-tabs-vertical .ui-widget-header {
            border: none;
        }

        .ui-tabs.ui-tabs-vertical .ui-tabs-nav {
            float: left;
            width: 12em;
            background: #CCC;
            border-radius: 4px 0 0 4px;
            border-right: 1px solid gray;
        }

            .ui-tabs.ui-tabs-vertical .ui-tabs-nav li {
                clear: left;
                width: 100%;
                margin: 0.2em 0;
                border: 1px solid gray;
                border-width: 1px 0 1px 1px;
                border-radius: 4px 0 0 4px;
                overflow: hidden;
                /*position: relative;*/
                /*right: -2px;*/
                /*z-index: 2;*/
            }

                .ui-tabs.ui-tabs-vertical .ui-tabs-nav li a {
                    display: block;
                    width: 100%;
                    padding: 0.6em 1em;
                }

                    .ui-tabs.ui-tabs-vertical .ui-tabs-nav li a:hover {
                        cursor: pointer;
                    }

                .ui-tabs.ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active {
                    margin-bottom: 0.2em;
                    padding-bottom: 0;
                    border-right: 1px solid white;
                }

                .ui-tabs.ui-tabs-vertical .ui-tabs-nav li:last-child {
                    margin-bottom: 10px;
                }

        .ui-tabs.ui-tabs-vertical.ui-tabs-panel {
            float: left;
            width: 72em;
            border-left: 1px solid gray;
            border-radius: 0;
            position: relative;
            left: -1px;
        }

    .ui-widget-content {
    }
</style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <b>Privilege Management</b>
                <br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
               <div class="row">
                            <div id="DivRight" >                                                                             
                                <div >                                     
                                    <div id="tabs">
                                         <ul></ul>                                      
                                    </div>
                                </div>
                            </div>                                              
                   </div>
        </div>
           </div>
     <script type="text/javascript">
         $(document).ready(function () {
                 loadPrescriptionView(function () {                
                 loadView(function () {                   
                     $("#tabs").tabs({
                         cache: true, //make click only load page once
                         ajaxOptions: { cache: false }, //but don't cache the ajax request!
                         active: 0, //first tab is active
                         disabled: false
                     });

                 });

             });
                 $("#tabs").tabs({
                     activate: function (event, ui) {
                         var ActiveTab = ui.newPanel.selector.replace("#", '');
                         if (ActiveTab == 1) {
                             $bindMenuDropDownNew();
                             bindFrameDropDownNew();
                         }
                         if (ActiveTab == 2) {
                             $bindLoginTypeDropDown();
                         }
                         if (ActiveTab == 3) {
                             $bindLoginTypeDropDown();
                             $bindDoctorDropDown();

                         }
                         if (ActiveTab == 4) {
                             $bindLoginTypeDropDown();
                         }
                     }
                 });
                 $('#DivRight').show();
                 $("#tabs").removeClass("ui-widget-content");

         });
         var loadView = function (callback) {
             $('#tabs div').each(function () {
                 $(this).load($(this).attr('view-href'), function (responseTxt, statusTxt, xhr) {
                     if (statusTxt == "success") {
                         $('#tabs').tabs('refresh');
                         $("#tabs").tabs({
                             cache: true, //make click only load page once
                             ajaxOptions: { cache: false }, //but don't cache the ajax request!
                             active: 0, //first tab is active
                             disabled: false
                         });
                        // $("#tabs").tabs("enable", 0);
                        // $("#tabs").tabs("option", "active", 0);
                     }
                 });
             });
             callback();
         }
      
         var loadPrescriptionView = function (callback) {
        
             serverCall('Services/PagePrivilage.asmx/loadMenuView', {}, function (response) {
                 var responseData = JSON.parse(response);
                 $.each(responseData, function (i, e) {
                     $('#tabs ul').append('<li><a href="#' + this.ID + '">' + this.AccordianName + '</a></li>');
                     $('#tabs').append('<div id="' + this.ID + '" view-href=' + this.ViewUrl + '></div>');
                 })
                 callback();
             })
         }        
         </script>
</asp:Content>

