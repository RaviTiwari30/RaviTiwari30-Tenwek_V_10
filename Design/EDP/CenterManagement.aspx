<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CenterManagement.aspx.cs" Inherits="Design_EDP_CenterManagement" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
                <b>Centre Management</b>
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
                                Centre Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                          
                            <%--<input type="text" id="txtCenterName" tabindex="1" />--%>
                            <select id="ddlAllCenter"></select>
                        </div>
                        <div class="col-md-3" style="display:none;">
                            <label class="pull-left">
                                Center ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none;">
                            <input type="text" id="txtCenterID" onkeypress="return isNumber(event)" maxlength="3" />
                        </div>
                        <div class="col-md-7"><input type="button" id="btnSearch" value="Search" onclick="SearchCenter()" class="ItDoseButton" />
                            &nbsp;
                            <input type="button" id="btnReset" value="Reset" onclick="ResetCenter()" class="ItDoseButton" />
                        </div>
                    </div>
                    </div>
                </div>
            <div class="row" id="DivCenterDetails"  style="display:none;">
                <div class="Purchaseheader">
                   Center Details
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-24">
                    <div id="CenterDetail" style="height:100px;overflow-y:scroll;">
                     </div>
                    <div id="EditCenterDetail" style="display: none;">
                        <div class="row">
                            <div class="row"></div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Center Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <span id="SpnCenterID" style="display: none;"></span>
                                <span id="SpnCenterName" style="font-weight: bold;"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Center Code
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <span id="SpnCenterCode" style="font-weight: bold;"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Address
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <span id="SpnAddress" style="font-weight: bold;"></span>
                            </div>
                        </div>
                    </div>
                    <span id="spnCenter_ID" style="display:none;"></span>
                    <span id="spnCenter_Name" style="display:none;"></span>
                    <span id="spnCenterwiseTolerance" style="display:none;"></span>
                    <span id="spnCenterSubcategoryMarkup" style="display:none;"></span>
                </div>
            </div>
            <div class="row">
                <div id="DivRight" style="font-size:8.6pt;">
                    <div>
                        <div id="tabs">
                            <ul></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script id="Center_Detail" type="text/html">
        <table class="GridViewStyle" style="">
            <thead>
                <tr>
                    <td class="GridViewHeaderStyle">S.N.</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Centre ID</td>
                    <td class="GridViewHeaderStyle">Center Name</td>
                    <td class="GridViewHeaderStyle">Address</td>
                    <td class="GridViewHeaderStyle">Contact</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Tab Position</td>
                    <td class="GridViewHeaderStyle">Centre Code</td>
                    <td class="GridViewHeaderStyle">Latitude</td>
                    <td class="GridViewHeaderStyle">Longitude</td>
                    <td class="GridViewHeaderStyle">Active</td>
                    <td class="GridViewHeaderStyle">Select</td>
                </tr>
            </thead>
            <tbody>
                <#dataLength=CenterData.length;
                for(var i=0;i<dataLength;i++)
                    {
                    objData=CenterData[i];
                #>
                    <tr class="text_data selected_grey">
                    <td class="GridViewItemStyle" id="tdsno"><#=(i+1)#></td>
                    <td class="GridViewItemStyle" id="tdCentreID" style="display:none;"><#=objData.CentreID#></td>
                    <td class="GridViewItemStyle" id="tdCentreName"><#=objData.CentreName#></td>
                    <td class="GridViewItemStyle" id="tdAddress"><#=objData.Address#></td>
                    <td class="GridViewItemStyle" id="tdMobileNo"><#=objData.MobileNo#></td>
                    <td class="GridViewItemStyle" id="tdTabPosition" style="display:none;"><#=objData.TabPosition#></td>
                    <td class="GridViewItemStyle" id="tdCentreCode"><#=objData.CentreCode#></td>
                    <td class="GridViewItemStyle" id="tdLatitude"><#=objData.Latitude#></td>
                    <td class="GridViewItemStyle" id="tdLongitude"><#=objData.Longitude#></td>
                    <td class="GridViewItemStyle" id="tdActive"><#=objData.Active#></td>
                    <td class="GridViewItemStyle"><img alt="select" src="../../Images/Post.gif" onclick="EditCenter(this);" style="cursor:pointer;" /></td>
                    </tr>
                <#}#>
            </tbody>
        </table>
    </script>

    <script type="text/javascript">

        $(document).ready(function () {
            $('#DivCenterDetails').hide();
            $('#DivRight').show();
            $("#spnCenterSubcategoryMarkup").text(<%= Resources.Resource.IsCentrewiseSubCategoryWiseMarkup%>);
            $('#spnCenterwiseTolerance').text(<%= Resources.Resource.IsCentrewiseTolerance%>);
            $bindAllCentre(function () { });
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

        var loadPrescriptionView = function (callback) {
            serverCall('CenterManagement.aspx/loadPrescriptionView', {}, function (response) {
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

        var $bindAllCentre = function (callback) {
            serverCall('../EDP/CenterManagement/CenterManagement.asmx/BindAllCentre', {}, function (response) {
                $Centre = $('#ddlAllCenter');
                var DefaultValue = "Select";
                $Centre.bindDropDown({ defaultValue: DefaultValue, data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: DefaultValue });
                callback($Centre.find('option:selected').text());
            });

        }

        function SearchCenter() {
           // var centerid=$('#txtCenterID').val();
            //if (centerid == "") {
            //    centerid = 0;
            //}
            var centerid = $('#ddlAllCenter option:selected').val();
            if (centerid == 0) {
                modelAlert("Please Select Center");
                return false;
            }
            $.ajax({
                url: 'CenterManagement.aspx/SearchCenter',
                data: JSON.stringify({ CenterName: "", CenterID: $('#ddlAllCenter option:selected').val() }),
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                type: 'POST',
                success: function (responce) {
                    if (responce.d != "") {
                        CenterData = JSON.parse(responce.d);
                        var OutData = $('#Center_Detail').parseTemplate(CenterData);
                        $('#CenterDetail').html(OutData);
                        $('#CenterDetail').show();
                        $('#DivCenterDetails').show();
                    }
                },
                error: function () { alert("Something went wrong.");}
            });
        }

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        function EditCenter(rowID) {
            var CenterID = $(rowID).closest('tr').find('#tdCentreID').text();
            var CenterName = $(rowID).closest('tr').find('#tdCentreName').text();
            var CenterCode = $(rowID).closest('tr').find('#tdCentreCode').text();
            var address = $(rowID).closest('tr').find('#tdAddress').text();
            $("#SpnCenterID").text(CenterID);
            $("#spnCenter_ID").text(CenterID);
            $("#SpnCenterName").text(CenterName);
            $("#spnCenter_Name").text(CenterName);
            $("#SpnCenterCode").text(CenterCode);
            $("#SpnAddress").text(address);
            $('#CenterDetail').hide();
            $('#EditCenterDetail').show();
            $("#tabs").tabs({
                cache: true, //make click only load page once
                ajaxOptions: { cache: false }, //but don't cache the ajax request!
                active: 0, //first tab is active
                disabled: false
            });
            $("#btnSearch,#ddlAllCenter").prop("disabled", true);//#txtCenterName,#txtCenterID"
            $('#ddlAllCenter').attr("disabled", true).chosen('destroy').chosen();//
            var TabPosition = 12;
            if (TabPosition >= 12) {
                $("#tabs").tabs("enable", TabPosition);
                $("#tabs").tabs({ active: TabPosition - 1 });
                $('#tabs').tabs('option', 'disabled', [])
            }
            else {
                $("#tabs").tabs("enable", TabPosition);
                $("#tabs").tabs({ active: TabPosition - 1 });
            }
        }

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
                    if (ActiveTab == 1) {

                        if ($("#spnCenter_ID").text() != '') {
                            GetCenterDetails($("#spnCenter_ID").text());
                           
                        }

                    }
                    else if (ActiveTab == 2) {
                        // GetSetCentre($("#spnCenter_ID").text()); GetUserAccess($("#spnCenter_ID").text());
                        getAllMappings($.trim($("#spnCenter_ID").text()), function () { }); // for employee
                       
                    }
                    else if (ActiveTab == 3) {
                        // GetRoleWisePages($("#spnCenter_ID").text());
                        GetAllDoctorMappings($.trim($("#spnCenter_ID").text()), function () { });//for doctors
                    }
                    else if (ActiveTab == 4) {
                        GetAllPanelsMappings($.trim($("#spnCenter_ID").text()), function () { });//for panels
                        //GetCenter($("#spnCenter_ID").text(), function () {

                        //    GetSetCentre($("#spnCenter_ID").text()); GetUserAccess($("#spnCenter_ID").text());

                        //    GetRoleWisePages($("#spnCenter_ID").text());

                        //    var cid = $('#ddlcenter').val();

                        //    GetDeptWiseAuth($("#spnCenter_ID").text(), cid);
                        //});
                    }
                    else if (ActiveTab == 5) {
                        GetAllRolesMappings(function () { });//for roles
                       // GetCenter_CP($("#spnCenter_ID").text()); GetUserNames($("#spnCenter_ID").text());
                    }
                    else if (ActiveTab == 6) {
                        GetAllRolesForPIMappings(function () { });
                    }
                    else if (ActiveTab == 7) {
                        GetAllRolesForDIMappings(function () { });
                    }
                }
            });
        });

        function ResetCenter() {
            $('#CenterDetail,#DivCenterDetails').hide();
            $("#SpnCenterID,#spnCenter_ID,#SpnCenterName").text('');
            $("#btnSearch,#ddlAllCenter").prop("disabled", false);//,#txtCenterName,#txtCenterID
            $('#ddlAllCenter').attr("disabled", false).chosen('destroy').chosen();//
            $("#txtCenterName").val('');
            $("#tabs").tabs({
                cache: true, //make click only load page once
                ajaxOptions: { cache: false }, //but don't cache the ajax request!
                active: 0, //first tab is active
                disabled: true
            });
            $("#tabs").tabs("enable", 0);
            $("#tabs").tabs("option", "active", 0);
            ClearCenter();
        }
    </script>
</asp:Content>

