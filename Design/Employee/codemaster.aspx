<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CodeMaster.aspx.cs" Inherits="Design_Employee_CodeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Code Master</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <input type="text" id="txtId" class="required" style="display: none" />
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">Code</label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-5">

                    <input type="text" id="txtCode" class="required" maxlength="4"  />
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Description</label>
                    <b class="pull-right">:</b>

                </div>

                <div class="col-md-13">
                    <textarea id="txtDescription" cols="10" rows="1" class="required" onkeypress="CheckSuggestedText(event,this.id)" ></textarea>
                </div>

            </div>

            <div class="row">
                <div class="col-md-24" style="text-align: center">

                    <input type="button" id="btnSave" value="Save" onclick="Save()" />

                    <input type="button" id="btnUpdate" value="Update" onclick="Update()" style="display: none" />
                </div>



            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <table id="tblCodeData" class="GridViewStyle" style="width: 100%">

                <thead>
                    <tr>

                        <td class="GridViewHeaderStyle">S.N.</td>
                        <td class="GridViewHeaderStyle" style="display: none">ID</td>
                        <td class="GridViewHeaderStyle" style="display: none">IsActive</td>
                        <td class="GridViewHeaderStyle">Code</td>
                        <td class="GridViewHeaderStyle">Description</td>
                        <td class="GridViewHeaderStyle">Status</td>
                        <td class="GridViewHeaderStyle">Edit</td>

                        <td class="GridViewHeaderStyle">Action</td>

                    </tr>
                </thead>
                <tbody>
                </tbody>

            </table>
        </div>
    </div>

    <script type="text/javascript">

        function Save() {
            var Code = $("#txtCode").val().toUpperCase();
            var Description = $("#txtDescription").val();


            if (Code == '' || Code == undefined) {

                modelAlert("Enter Code");
                return false
            }
            if (Description == '' || Description == undefined) {

                modelAlert("Enter Description");
                return false
            }



            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('CodeMaster.aspx/Savedata', { Code: Code, Description: Description }, function (response) {
                var $responseData = JSON.parse(response);

                if ($responseData.status) {
                    modelAlert($responseData.response, function () {
                        Clear();
                        GetCodeData();

                    });
                    $(btnSave).removeAttr('disabled').val('Save');

                }
                else {
                    $(btnSave).removeAttr('disabled').val('Save');
                    modelAlert($responseData.response);

                }

            });



        };

        $(document).ready(function () {
            GetCodeData();

            ShowButton(0);


        });

        function Activate(Id) {





            modelConfirmation('Alert!!!', 'Do You Want To Activate ?', 'Activate', 'Close', function (response) {
                if (response) {

                    serverCall('CodeMaster.aspx/Activate', { Id: Id }, function (response) {
                        var $responseData = JSON.parse(response);

                        if ($responseData.status) {
                            modelAlert($responseData.response, function () {
                                GetCodeData();

                            });

                        }
                        else {

                            modelAlert($responseData.response);

                        }

                    });
                }
            });



        }

        function DeActivate(Id) {


            modelConfirmation('Alert!!!', 'Do You Want To DeActivate ?', 'DeActivate', 'Close', function (response) {
                if (response) {

                    serverCall('CodeMaster.aspx/DeActivate', { Id: Id }, function (response) {
                        var $responseData = JSON.parse(response);

                        if ($responseData.status) {
                            modelAlert($responseData.response, function () {
                                GetCodeData();
                            });


                        }
                        else {

                            modelAlert($responseData.response);

                        }

                    });
                }
            });




        }

        function GetCodeData() {

            serverCall('CodeMaster.aspx/GetCodeData', {}, function (response) {

                var CodeData = JSON.parse(response);

                if (CodeData.status) {
                    data = CodeData.data;
                    $('#tblCodeData tbody').empty();
                    $.each(data, function (i, item) {
                        var rows = "";
                        var funct = "";
                        var btnVal = "";
                        var btnColor = "";
                        if (item.IsActive == 0) {
                            btnVal = "Activate";
                            funct = "Activate('" + item.Id + "')";
                            btnColor = "background-color:Green;font-weight:bolder;";

                        }
                        else if (item.IsActive == 1) {
                            btnVal = "DeActivate";
                            funct = "DeActivate('" + item.Id + "')";
                            btnColor = "background-color:red;font-weight:bolder;";
                        }

                        rows += '<tr>'
                        rows += '<td class="GridViewLabItemStyle">' + ++i + '</td>'
                        rows += '<td class="GridViewLabItemStyle" style="Display:none"><label id="tdId" >' + item.Id + '</label> </td>'
                        rows += '<td class="GridViewLabItemStyle" style="Display:none"><label id="tdIsActive" >' + item.IsActive + '</label>  </td>'
                        rows += '<td class="GridViewLabItemStyle"><label id="tdCode">' + item.Code + '</label>  </td>'
                        rows += '<td class="GridViewLabItemStyle"><label id="tddesciption">' + item.Description + '</label>  </td>'
                        rows += '<td class="GridViewLabItemStyle"><label id="tdStatus">' + item.STATUS + '</label></td>'

                        rows += '<td class="GridViewLabItemStyle"><input type="button" id="btnUpdate"  value="Edit" onclick="Edit(this)" /></td>'
                        rows += '<td class="GridViewLabItemStyle"><input type="button" style=' + btnColor + ' id="btnStatusUpdate"  value=' + btnVal + ' onclick=' + funct + ' /></td>'

                        rows += '</tr>'


                        $('#tblCodeData').append(rows);
                    });

                }

                $('#tblCodeData').show();

            });
        }

        function Edit(RowID) {

            var ID = $(RowID).closest('tr').find('#tdId').text();
            var Code = $(RowID).closest('tr').find('#tdCode').text();
            var Description = $(RowID).closest('tr').find('#tddesciption').text();

            $("#txtCode").val(Code);
            $("#txtDescription").val(Description);
            $("#txtId").val(ID);

            ShowButton(1);
        }

        function Clear() {
            $("#txtCode").val("");
            $("#txtDescription").val("");
            $("#txtId").val("");


        }
        function Update() {

            modelConfirmation('Alert!!!', 'Do You Want To Update ?', 'Yes', 'No', function (response) {
                if (response) {
                    var Code = $("#txtCode").val();
                    var Description = $("#txtDescription").val();
                    var Id = $("#txtId").val();

                    if (Code == '' || Code == undefined) {

                        modelAlert("Erroe in  Code");
                        return false
                    }
                    if (Description == '' || Description == undefined) {

                        modelAlert("Enter Description");
                        return false
                    }

                    serverCall('CodeMaster.aspx/Update', { Id: Id, Description: Description }, function (response) {
                        var $responseData = JSON.parse(response);

                        if ($responseData.status) {
                            modelAlert($responseData.response, function () {
                                ShowButton(0);
                                GetCodeData();
                            });


                        }
                        else {

                            modelAlert($responseData.response, function () {
                                ShowButton(1);
                            });

                        }

                    });
                }
            });


        }

        function ShowButton(ID) {

            if (ID == 0) {
                Clear();
                $("#txtCode").attr("disabled", false);
                $("#btnSave").show();
                $("#btnUpdate").hide();
            } else {
                $("#txtCode").attr("disabled", true);
                $("#btnSave").hide();
                $("#btnUpdate").show();
            }
        };


              
        
        </script>
</asp:Content>

