<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="userprivilege.aspx.cs" Inherits="Design_EDP_userprivilege" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
                <b>Privilege Management</b>
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
                                Employee Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                          
                            <input type="text" id="txtName" tabindex="1" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="cmbDept" tabindex="2"></select>
                        </div>
                        <div class="col-md-7"><input type="button" id="btnSearch" value="Search" onclick="SearchEmp()" class="ItDoseButton" />
                            &nbsp;
                            <input type="button" id="btnReset" value="Reset" onclick="ResetEmp()" class="ItDoseButton" />
                               &nbsp;
                            <input type="button" id="btncopyrole" value="Copy Role Right" onclick="openRoleright1()" class="ItDoseButton" />
                        
                        </div>
                    </div>
                    </div>
                </div>
             <div class="row" id="DivEMPDetails"  style="display:none;">
                   <div class="Purchaseheader">
                   Employee Details
                   </div>
                 <div class="col-md-1"></div>
                 <div class="col-md-24">
                    
                     <div id="EmpDetail" style="height:100px;overflow-y:scroll;">

                     </div>

                     <div id="EditEmpDetail" style="display:none;">
                              <div class="row">
                                 <div class="row"></div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Employee Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <span id="SpnEmpID" style="display:none;"></span>
                                    <span id="SpnEmpName" style="font-weight:bold;"></span>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                       Father's Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                  
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Department
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    
                                </div>
                            </div>
                         </div>


                     <span id="empid" style="display:none;"></span>
                       <span id="SpnTabPosition" style="display:none;"></span>
                 </div>
             </div>

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
    



    <!--/Model Popup for Copy Role And Rights/-->
<div id="CopyRoleRight1" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content " style="width: 80%">
            <div class="modal-header">
                <button type="button" class="close" onclick="CloseCopyRoleRightModel1()" aria-hidden="true">&times;</button>
                <b class="modal-title">Copy Role & Rights</b>
            </div>
            <div class="modal-body">
                <div class="row">

                      <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">
                           Copy from  Employee 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">                          
                            <input type="text" id="txtModelName1" tabindex="1" />
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlDept1"></select>     
                           
                        </div>
                        <div class="col-md-3"><input type="button" id="btnModelSearch1" value="Search" onclick="SearchModelEmp1()" class="ItDoseButton" />
                           
                        </div>
                    </div>

                   
                </div>


                 <div class="row" id="DivModelEMPDetails1"  style="display:none; margin-top:4px">
                   <div class="Purchaseheader">
                  Copy From Employee Details
                   </div>
                 <div class="col-md-1"></div>
                 <div class="col-md-24">
                    
                     <div id="ModelEmpDetail1" style="height:100px;overflow-y:scroll;">

                     </div>

                 </div>
             </div>
               
                <div class="row" id="information1" style="display:none;margin-top:4px">
                     <div class="col-md-6">
                                    <label class="pull-left">
                                      Selected Copy From  Employee 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                   
                                    <span id="FromEmployeeName1" style="font-weight:bold;"></span>
                                </div>
                </div>

                 <div class="row" id="DivCopyToEmployee" style="display:none">
                        <div class="col-md-6">
                            <label class="pull-left">
                             Copy To Employee
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">                          
                            <input type="text" id="TxtEmpCopyTo" tabindex="1" />
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlEmpCopyTo"></select>     
                           
                        </div>
                        <div class="col-md-3"><input type="button" id="BtnCopyToSearch" value="Search " onclick="SearchEmpToBindForCopy()" class="ItDoseButton" />
                           
                        </div>
                    </div>


                    
                 <div class="row" id="EmolyeeModelToChangeRole"  style="display:none; margin-top:4px">
                   <div class="Purchaseheader" >
                   Select Employee To Change Role Right 
                   </div>
                 <div class="col-md-1"></div>
                  <div class="col-md-24">
                    
                     <div id="ModelEmployeeToChangeRole" style="height:100px;overflow-y:scroll;">

                     </div>

                 </div>
             </div>
                  
                 <div class="row" id="DivTblAppend"  style="display:none; margin-top:4px">
                   <div class="Purchaseheader" >
                   Employee Having Pending Role Right
                   </div>
                 <div class="col-md-1"></div>
                 <div class="col-md-24" style="height:100px;overflow-y:scroll">
                    
                     <table id="tblcopyemployee"  class="GridViewStyle"  style="width:95%;">

                         <thead>
                             <tr>

                                   <td class="GridViewHeaderStyle">S.N.</td>
                   
                                    <td class="GridViewHeaderStyle">Employee Name</td>
                                    <td class="GridViewHeaderStyle">Address</td>
                                    <td class="GridViewHeaderStyle">Contact</td>
                                    <td class="GridViewHeaderStyle">Active</td>
                                    <td class="GridViewHeaderStyle"><input type="checkbox" id="EmployeeIdSelectAll" /> Select</td>
             

                             </tr>
                         </thead>
                         <tbody>
                             
                         </tbody>

                     </table>
                   

                 </div>
             </div>



                <input id="SelectedEmployeeId1" type="hidden"  />
                    

            </div>
            <div class="modal-footer">
                
               <input style="width: 80px" type="button" id="btnModelSave" class="btnModelSave" runat="server" value="Save" onclick="BulkCopyRoleRightOFUser()" disabled="true" />
             
                <button type="button" onclick="CloseCopyRoleRightModel1()">Close</button>
            </div>
        </div>
    </div>
</div>

<!--\End Of Model PopUp\-->


    <script type="text/javascript">

        var searchemprowcount = 2;
        function SearchEmp() {
            $.ajax({
                data: JSON.stringify({ EmpName: $('#txtName').val(), Department: $('#cmbDept').val() }),
                dataType: 'JSON',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                url: 'userprivilege.aspx/SearchEmp',
                success: function (responce) {
                    if (responce.d != "") {
                        EmpData = JSON.parse(responce.d);
                        var OutData = $('#sc_EMP_detail').parseTemplate(EmpData);
                        $('#EmpDetail').html(OutData);
                        $('#EmpDetail').show();
                        $('#DivEMPDetails').show();
                    }
                },
                error: function () { }
            });
        }

        function ResetEmp() {
            $('#EmpDetail,#DivEMPDetails,#EditEmpDetail').hide();
            $("#empid,#SpnEmpID,#SpnEmpName").text('');
            $("#btnSearch,#txtName,#cmbDept").prop("disabled", false);
            $("#txtName").val('');
            $("#tabs").tabs({
                cache: true, //make click only load page once
                ajaxOptions: { cache: false }, //but don't cache the ajax request!
                active: 0, //first tab is active
                disabled: true
            });
            $("#tabs").tabs("enable", 0);
            $("#tabs").tabs("option", "active", 0);
            ClearEmpDetail();
        }

        var getDepartment = function (callback) {
            var ddlDepartment = $('#cmbDept');
            serverCall('userprivilege.aspx/GetRoles', {}, function (response) {
                callback($(ddlDepartment).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', isSearchable: true }));
            });
        }

        function EditEmployee(rowID) {

            var EmpId = $(rowID).closest('tr').find('#tdEmployeeID').text();

            var EmpName = $(rowID).closest('tr').find('#tdName').text();
            var TabPosition = $(rowID).closest('tr').find('#tdTabPosition').text();
            $("#empid").text(EmpId); $("#SpnEmpID").text(EmpId);
            $("#SpnTabPosition").text(TabPosition);
            $("#SpnEmpName").text(EmpName);
            $('#EmpDetail').hide();
            $('#EditEmpDetail').show();
            $("#tabs").tabs({
                cache: true, //make click only load page once
                ajaxOptions: { cache: false }, //but don't cache the ajax request!
                active: 0, //first tab is active
                disabled: false
            });
            $("#btnSearch,#txtName,#cmbDept").prop("disabled", true);
            if (TabPosition >= 5) {
                $("#tabs").tabs("enable", TabPosition);
                $("#tabs").tabs({ active: TabPosition - 1 });
                $('#tabs').tabs('option', 'disabled', [])
            }
            else {
                $("#tabs").tabs("enable", TabPosition);
                $("#tabs").tabs({ active: TabPosition - 1 });
            }
            //GetSetCentre(EmpId);
            //GetUserNames(EmpId);
            //GetUserAccess(EmpId);
            //GetRoleWisePages(EmpId);

            //GetEmpDetails(EmpId);
            //GetCenter(EmpId);
            ////GetDeptWiseAuth(EmpId, 1);
            //GetCenter_CP(EmpId);

        }
        //data: JSON.stringify({ EmpID: EmployeeID }),
        function SearchEmpByEmpID(EmployeeID) {
            $.ajax({
                data: '{EmpID:"' + EmployeeID + '"}',
                dataType: 'JSON',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                url: 'userprivilege.aspx/SearchEmpByEmpID',
                success: function (responce) {
                    if (responce.d != "") {
                        EmpData = JSON.parse(responce.d);
                        var OutData = $('#sc_EMP_detail').parseTemplate(EmpData);
                        $('#EmpDetail').html(OutData);
                        $('#EmpDetail').show();
                        $('#DivEMPDetails').show();
                        $('#EmpDetail tbody tr:first img').trigger('click');
                    }
                },
                error: function () { }
            });
        }

        $(document).ready(function () {
            getDepartment(function () { });
            $('#DivEMPDetails').hide();
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

                        if ($("#empid").text() != '') {
                            GetEmpDetails($("#empid").text());
                        }

                    }
                    else if (ActiveTab == 2) {
                        GetSetCentre($("#empid").text()); GetUserAccess($("#empid").text());

                    }
                    else if (ActiveTab == 3) {
                        GetRoleWisePages($("#empid").text());
                    }
                    else if (ActiveTab == 4) {
                        GetSetCentre($("#empid").text()); GetUserAccess($("#empid").text());

                        GetRoleWisePages($("#empid").text())
                        GetCenter($("#empid").text(), function (selectedCentreID) {
                         //   var cid = $('#ddlcenter').val();
                            GetDeptWiseAuth($("#empid").text(), selectedCentreID);
                        });

                    }
                    else if (ActiveTab == 5) {
                        GetCenter_CP($("#empid").text()); GetUserNames($("#empid").text());
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
            serverCall('UserPrivilege.aspx/loadPrescriptionView', {}, function (response) {
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



        //Copy Role Right js//




        function CloseCopyRoleRightModel1() {
            $('#CopyRoleRight1').closeModel();
        }
        function OpenCopyRoleRightModel1() {
            $('#CopyRoleRight1').showModel();
        }

        var $ddlGetEmolyee1 = function (callback) {
            var ddlDepartment = $('#ddlDept1');
            serverCall('userprivilege.aspx/GetRoles', {}, function (response) {
                ($(ddlDepartment).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', isSearchable: true }));
            });
        }

        var $ddlGetEmolyee2 = function (callback) {
            var ddlDepartment = $('#ddlEmpCopyTo');
            serverCall('userprivilege.aspx/GetRoles', {}, function (response) {
                ($(ddlDepartment).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', isSearchable: true }));
            });
        }
        function openRoleright1() {

            $ddlGetEmolyee1();
            $ddlGetEmolyee2();
            OpenCopyRoleRightModel1();



        }

        function SelectedEmpID1(Id) {
        
            var EmpId = $(Id).closest('tr').find('#tdID').text();

            var EmpName = $(Id).closest('tr').find('#tdNames').text();

            $('#information1').show();
            $("#SelectedEmployeeId1").val(EmpId);
            $("#FromEmployeeName1").text(EmpName);

            $('#ModelEmpDetail1').hide();
            $('#DivModelEMPDetails1').hide();
            $('#DivCopyToEmployee').show();

            $('.btnModelSave').removeAttr("disabled");


            BindSearchTable();

        }

        function AppendToPendigRoleTable(Id) {
            --searchemprowcount;
            var EmpId = $(Id).closest('tr').find('#TdCrEmpId').text();

            var EmpName = $(Id).closest('tr').find('#TdCrName').text();

            var Address = $(Id).closest('tr').find('#TdCrHouse').text();

            var Contact = $(Id).closest('tr').find('#TdCrPhone').text();
            var Active = $(Id).closest('tr').find('#TdCrActive').text();

            $(Id).closest('tr').hide();

            var rowCount = $('#tblcopyemployee tbody tr').length;

            var rows = "<tr>" + "<td class='GridViewStyle'>" + ++rowCount + "</td>" + "<td class='GridViewStyle' id='tdappendempid'  style='display:none'>" + EmpId + "</td>" + "<td class='GridViewStyle'>" + EmpName + "</td>" + "<td class='GridViewStyle'>" + Address + "</td>" + "<td class='GridViewStyle'>" + Contact + "</td>" + "<td class='GridViewStyle'>" + Active + "</td>" + "<td class='GridViewStyle'><input type='checkbox' id='" + EmpId + "' value='" + EmpId + "' name='ChkEmpCopyTo' class='ChkEmpCopyTo'  checked /></td>" + "</tr>";

            $('#tblcopyemployee tbody').append(rows);
            $("#DivTblAppend").show();
            if (searchemprowcount <= 0) {

                $('#ModelEmployeeToChangeRole').hide();
                $('#EmolyeeModelToChangeRole').hide();
            }


        }


      
        function SearchModelEmp1() {
            $.ajax({
                data: JSON.stringify({ EmpName: $('#txtModelName1').val(), Department: $('#ddlDept1').val() }),
                dataType: 'JSON',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                url: 'userprivilege.aspx/SearchEmpforCopyFromBind',
                success: function (responce) {
                    if (responce.d != "") {
                        EmpData = JSON.parse(responce.d);
                        var OutData = $('#sc_Model_EMP_detail1').parseTemplate(EmpData);
                        $('#ModelEmpDetail1').html(OutData);
                        $('#ModelEmpDetail1').show();
                        $('#DivModelEMPDetails1').show();
                    }
                },
                error: function () { }
            });
        }


        function SearchEmpToBindForCopy() {
            $.ajax({
                data: JSON.stringify({ EmpName: $('#txtModelName1').val(), Department: $('#ddlDept1').val() }),
                dataType: 'JSON',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                url: 'userprivilege.aspx/SearchEmpToBindForCopy',
                success: function (responce) {
                    if (responce.d != "") {
                        EmpData = JSON.parse(responce.d);
                        var OutData = $('#ScModelTochangeRole').parseTemplate(EmpData);
                        $('#ModelEmployeeToChangeRole').html(OutData);
                        $('#ModelEmployeeToChangeRole').show();
                        $('#EmolyeeModelToChangeRole').show();
                    }
                },
                error: function () { }
            });
        }


        function BindSearchTable() {
            $.ajax({
                data: {},
                dataType: 'JSON',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                url: 'userprivilege.aspx/SearchEmpforCopyToBind',
                success: function (responce) {
                    if (responce.d != "") {

                        EmpData = JSON.parse(responce.d);
                        //var OutData = $('#sc_Model_EMP_detail1').parseTemplate(EmpData);
                        console.log(EmpData)
                        $('#tblcopyemployee tbody').empty();
                        var data = JSON.parse(responce.d);
                        var count = 0;
                        $.each(data, function (i, item) {
                            var rows = "<tr>" + "<td class='GridViewStyle'>" + ++count + "</td>" + "<td class='GridViewStyle' id='tdappendempid'  style='display:none'>" + item.EmployeeID + "</td>" + "<td class='GridViewStyle'>" + item.NAME + "</td>" + "<td class='GridViewStyle'>" + item.House_No + "</td>" + "<td class='GridViewStyle'>" + item.Phone + "</td>" + "<td class='GridViewStyle'>" + item.Active + "</td>" + "<td class='GridViewStyle'><input type='checkbox' id='" + item.EmployeeID + "' value='" + item.EmployeeID + "' name='ChkEmpCopyTo' class='ChkEmpCopyTo' /></td>" + "</tr>";

                            $('#tblcopyemployee tbody' ).append(rows);
                        });

                        $("#DivTblAppend").show();
                    }
                },
                error: function () { }
            });
        }



        $('#EmployeeIdSelectAll').click(function () {
            if ($(this).is(":checked")) {
                $(".ChkEmpCopyTo").prop("checked", true)


            }

            else {
                $(".ChkEmpCopyTo").prop("checked", false)

            }
        });




        var BulkCopyRoleRightOFUser = function () {
            var CopyEmployeeID = $('#SelectedEmployeeId1').val();

            var EmployeeID = new Array();


            if (CopyEmployeeID == '') {
                modelAlert('Select user ! from Copy Role and Right.');
                return false;
            }
            // Parent checked check box value
            $('#tblcopyemployee tbody .ChkEmpCopyTo:checked').each(function () {
                EmployeeID.push($(this).val());
            });

            if (EmployeeID == '') {
                modelAlert('Select atleast one user ! to Copy Role and Right.');
                return false;
            }

            var obj = {
                EmployeeID: EmployeeID,
                CopyEmployeeID: CopyEmployeeID,
            };

            var data = JSON.stringify(obj)


            $.ajax({
                url: '../EDP/UserPrivilege/UserPrivilege.asmx/BulkCopyRoleRight',
                contentType: 'application/json; charset=utf-8',
                type: 'POST',
                data: JSON.stringify(obj),
                cache: false,
                success: function () {
                    modelAlert('Record Saved Successfully');
                    CloseCopyRoleRightModel1();

                    $('#information1').hide();
                    $("#SelectedEmployeeId1").val('');
                    $("#FromEmployeeName1").text('');

                    $('#tblcopyemployee tbody').empty();
                    $("#DivTblAppend").hide();
                },
                error: function (xhr, status, error) {
                    modelAlert('Some Error Occured  while saveing Role');
                }
            });




        };


        //End Js//
    </script>




    <script id="sc_EMP_detail" type="text/html">
        <table class="GridViewStyle" style="width:90%;">
            <thead>
                <tr>
                    <td class="GridViewHeaderStyle">S.N.</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Employee ID</td>
                    <td class="GridViewHeaderStyle">Employee Name</td>
                    <td class="GridViewHeaderStyle">Address</td>
                    <td class="GridViewHeaderStyle">Contact</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Tab Position</td>
                    <td class="GridViewHeaderStyle">Active</td>
                    <td class="GridViewHeaderStyle">Select</td>
                </tr>
            </thead>
            <tbody>
                <#dataLength=EmpData.length;
                for(var i=0;i<dataLength;i++)
                    {
                    objData=EmpData[i];
                #>
                    <tr class="text_data selected_grey">
                    <td class="GridViewItemStyle" id="tdsno"><#=(i+1)#></td>
                    <td class="GridViewItemStyle" id="tdEmployeeID" style="display:none;"><#=objData.EmployeeID#></td>
                    <td class="GridViewItemStyle" id="tdName"><#=objData.NAME#></td>
                    <td class="GridViewItemStyle" id="tdHouse_No"><#=objData.House_No#></td>
                    <td class="GridViewItemStyle" id="tdPhone"><#=objData.Phone#></td>
                    <td class="GridViewItemStyle" id="tdTabPosition" style="display:none;"><#=objData.TabPosition#></td>
                    <td class="GridViewItemStyle" id="tdActive"><#=objData.Active#></td>
                    <td class="GridViewItemStyle"><img alt="select" src="../../Images/Post.gif" onclick="EditEmployee(this);" /></td>
                    </tr>
                    <#}#>
            </tbody>
        </table>
    </script>


     <script id="sc_Model_EMP_detail1" type="text/html">
        <table class="GridViewStyle" style="width:95%;">
            <thead>
                <tr>
                    <td class="GridViewHeaderStyle">S.N.</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Employee ID</td>
                    <td class="GridViewHeaderStyle">Employee Name</td>
                    <td class="GridViewHeaderStyle">Address</td>
                    <td class="GridViewHeaderStyle">Contact</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Tab Position</td>
                    <td class="GridViewHeaderStyle">Active</td>
                    <td class="GridViewHeaderStyle">Select</td>
                </tr>
            </thead>
            <tbody>
                <#dataLength=EmpData.length;
                for(var i=0;i<dataLength;i++)
                    {
                    objData=EmpData[i];
                #>
                    <tr class="text_data selected_grey">
                    <td class="GridViewItemStyle" id="tdSn"><#=(i+1)#></td>
                    <td class="GridViewItemStyle" id="tdID" style="display:none;"><#=objData.EmployeeID#></td>
                    <td class="GridViewItemStyle" id="tdNames"><#=objData.NAME#></td>
                    <td class="GridViewItemStyle" id="tdHouse"><#=objData.House_No#></td>
                    <td class="GridViewItemStyle" id="tdPhones"><#=objData.Phone#></td>
                    <td class="GridViewItemStyle" id="tdTabPosi" style="display:none;"><#=objData.TabPosition#></td>
                    <td class="GridViewItemStyle" id="tdAct"><#=objData.Active#></td>
                    <td class="GridViewItemStyle"><img alt="select" src="../../Images/Post.gif" onclick="SelectedEmpID1(this);" /></td>
                    </tr>
                    <#}#>
            </tbody>
        </table>
    </script>

     

     <script id="ScModelTochangeRole" type="text/html">
        <table id="tblTochangeRole" class="GridViewStyle" style="width:95%;">
            <thead>
                <tr>
                    <td class="GridViewHeaderStyle">S.N.</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Employee ID</td>
                    <td class="GridViewHeaderStyle">Employee Name</td>
                    <td class="GridViewHeaderStyle">Address</td>
                    <td class="GridViewHeaderStyle">Contact</td>
                    <td class="GridViewHeaderStyle" style="display:none;">Tab Position</td>
                    <td class="GridViewHeaderStyle">Active</td>
                    <td class="GridViewHeaderStyle">Select</td>
                </tr>
            </thead>
            <tbody>
                <#dataLength=EmpData.length;
                for(var i=0;i<dataLength;i++)
                    {
                    objData=EmpData[i];
                #>
                    <tr class="text_data selected_grey">
                    <td class="GridViewItemStyle" id="TdCrSn"><#=(i+1)#></td>
                    <td class="GridViewItemStyle" id="TdCrEmpId" style="display:none;"><#=objData.EmployeeID#></td>
                    <td class="GridViewItemStyle" id="TdCrName"><#=objData.NAME#></td>
                    <td class="GridViewItemStyle" id="TdCrHouse"><#=objData.House_No#></td>
                    <td class="GridViewItemStyle" id="TdCrPhone"><#=objData.Phone#></td>
                    <td class="GridViewItemStyle" id="TdCrTabPosition" style="display:none;"><#=objData.TabPosition#></td>
                    <td class="GridViewItemStyle" id="TdCrActive"><#=objData.Active#></td>
                    <td class="GridViewItemStyle"><img alt="select" src="../../Images/Post.gif" onclick="AppendToPendigRoleTable(this);" /></td>
                    </tr>
                    <#}#>
            </tbody>
        </table>
    </script>

     

</asp:Content>







 