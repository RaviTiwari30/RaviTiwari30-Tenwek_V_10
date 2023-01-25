<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="RoleManager.aspx.cs" Inherits="Design_EDP_RoleManager" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
        <ajax:ScriptManager ID="sm" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <b>Role Management</b>
                <br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Privilege 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRole" tabindex="2"></select>

                            <input id="txtRoleID" type="hidden" />
                            <input id="txtRoleName" type="hidden" />
                        </div>

                        <div class="col-md-7">
                            <input type="button" id="btnSearch" value="Edit" class="ItDoseButton" onclick="BindRoleIDToText()" />
                             &nbsp;
                            <input type="button" id="btnReset" value="Reset" onclick="ResetRole()" class="ItDoseButton" />
                           
                        </div>
                    </div>
                </div>
            </div>
          
        </div>
          <div class="row">
                <input type="hidden" id="txtTabPosition" />
                <div id="DivRight">
                    <div>

                        <div id="tabs">
                            <div class="POuter_Box_Inventory" style="margin-left:-6px">
                                <ul></ul>

                            </div>

                        </div>
                    </div>

                </div>
            </div>
    </div>



    <script type="text/javascript">


        $(document).ready(function () {

            $ddlGetRole();

            $('#DivRight').show();
            // $('#tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');               
            loadPrescriptionView(function () {
                loadView(function () {
                    $("#tabs").tabs({
                        cache: true, //make click only load page once
                        ajaxOptions: { cache: false }, //but don't cache the ajax request!
                        active: 0, //first tab is active
                        disabled: true
                    });
                    $("#tabs").removeClass("ui-widget-content")
                });
            });

        });

        $(function () {
            $('#tabs ul').click(function () {
                //var activeTab = $(this).find("li a").attr("href");
                //var id = $(this).attr('href').replace("#", ''); // Extract the new tab ID
                //$('#tabs').tabs('select', id); // And activate it              
                return false;
            });

            $("#tabs").tabs({
                activate: function (event, ui) {
                    var ActiveTab = ui.newPanel.selector.replace("#", '');
                    //var $activeTab = $('#tabs').tabs('option', 'active');
                    if (ActiveTab == 1) {

                        if ($("#txtRoleID").val() != '') {
                            GetRoleToEdit($("#txtRoleID").val());

                        }

                    }
                    else if (ActiveTab == 2) {
                        if ($("#txtRoleID").val() != '') {

                            BindCentreTable($("#txtRoleID").val())
                        }

                    }
                    else if (ActiveTab == 3) {
                        $ddlCentres();
                    }
                    else if (ActiveTab == 4) {
                        if ($("#txtRoleID").val() != '') {

                            BindlabDept($("#txtRoleID").val())
                        }


                    }
                    else if (ActiveTab == 5) {
                        if ($("#txtRoleID").val() != '') {
                            getMappings($("#txtRoleID").val(), function () {
                                checkAlreadyMapped(function () { });
                            });
                        }



                    }
                    else if (ActiveTab == 6) {
                        if ($("#txtRoleID").val() != '') {
                            BindDepartmentBelong($("#txtRoleID").val())
                           
                        }



                    }
                }
            });

            //$("#tabs").tabs({
            //    cache: true, //make click only load page once
            //    ajaxOptions: { cache: false }, //but don't cache the ajax request!
            //    active: 0, //first tab is active
            //    disabled: true
            //});
            //$("#tabs").tabs("enable", 0);
            //$("#tabs").tabs("option", "active", 0);
            //$('#tabs').tabs('option', 'disabled', []);
        });

        $.expr[':'].containsIgnoreCase = function (n, i, m) {
            return jQuery(n).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
        };
        var loadPrescriptionView = function (callback) {

            serverCall('RoleManager.aspx/RoleView', {}, function (response) {
                var responseData = JSON.parse(response);

                $.each(responseData, function (i, e) {
                    $('#tabs ul').append('<li><a href="#' + this.ID + '">' + this.AccordianName + '</a></li>');
                    $('#tabs').append('<div id="' + this.ID + '" view-href=' + this.ViewUrl + '></div>');
                })
                callback();
            })
        }

        var loadView = function (callback) {
            $('#tabs div').each(function () {
                $(this).load($(this).attr('view-href'), function (responseTxt, statusTxt, xhr) {
                    if (statusTxt == "success") {
                        $('#tabs').tabs('refresh');
                        $("#tabs").tabs({
                            cache: true, //make click only load page once
                            ajaxOptions: { cache: false }, //but don't cache the ajax request!
                            active: 0, //first tab is active
                            disabled: true
                        });
                        $("#tabs").tabs("enable", 0);
                        $("#tabs").tabs("option", "active", 0);
                    }
                });
            });
            callback();
        }


        var $ddlGetRole = function (callback) {
            var ddlRole = $('#ddlRole');
            serverCall('RoleManager.aspx/GetRole', {}, function (response) {
                ($(ddlRole).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', isSearchable: true }));
            });
        }

        //End Js//


        //Start  Get Data To Edit//

        function BindRoleIDToText() {
            var RoleID = $("#ddlRole").val();
            var RoleName = $("#ddlRole option:selected").val();
            $('#txtRoleID').val(RoleID);
            $('#txtRoleName').val(RoleName);
            $('#btnUpdateRole').show();

            $('#btnSaveRole').hide();

            if ($("#txtRoleID").val() != '') {
                GetRoleToEdit(RoleID);

            }
            var TabPosition = 1;
            if ($("#txtTabPosition").val() != null) {
                TabPosition = Number($("#txtTabPosition").val())
            }
            $("#tabs").tabs({
                cache: true, //make click only load page once
                ajaxOptions: { cache: false }, //but don't cache the ajax request!
                active: 0, //first tab is active
                disabled: false
            });

            if (TabPosition >= 6) {
                $("#tabs").tabs("enable", TabPosition);
                $("#tabs").tabs({ active: TabPosition - 1 });
                $('#tabs').tabs('option', 'disabled', [])
            }
            else {
                $("#tabs").tabs("enable", TabPosition);
                $("#tabs").tabs({ active: TabPosition - 1 });
            }

        }

        function ResetRole() {
            
            //$("#txtRoleID").val('');
            //$("#txtRoleName").val('');
            //$("#tabs").tabs({
            //    cache: true, //make click only load page once
            //    ajaxOptions: { cache: false }, //but don't cache the ajax request!
            //    active: 0, //first tab is active
            //    disabled: true
            //});
            //$("#tabs").tabs("enable", 0);
            //$("#tabs").tabs("option", "active", 0);
            //clearAllData();

            location.reload();
        }


        //End//

    </script>


</asp:Content>
