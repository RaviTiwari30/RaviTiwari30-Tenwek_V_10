<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapBioMedicalWithDepartment.aspx.cs" Inherits="Design_Biomedicalwaste_MapBioMedicalWithDepartment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            Getdata(0, function () { });
            BindDepartment(function () { });


        });

        var BindDepartment = function (callback) {
            $ddlDepartment = $('#ddlDepartment');
            serverCall('Services/BioMedicalwaste.asmx/BindRoleMaster', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchAble: true });
                callback($ddlDepartment.find('option:selected').text());
            });
        }
        //function BindBagType() {
        //    debugger;
        //    serverCall('Services/BioMedicalwaste.asmx/BindImage', { data: '' }, function (response) {
        //        var responseData = JSON.parse(response);
        //        BindImage(responseData);

        //    });
        //}
        function BindImage(data) {
            debugger;
            var row = '';
            $('#divimageBind').empty();
            for (var i = 0; i < data.length; i++) {
                row += '<div class="gallery">';
                if (data[i].IsMapped == '0')
                    row += '<div> <input class="largerCheckbox" type="checkbox" id="chkbagid" value=' + data[i].ID + '><input type="hidden" id="hdnId"  value=' + data[i].ID + '>';
                else
                    row += '<div> <input class="largerCheckbox" type="checkbox" id="chkbagid" checked="checked" value=' + data[i].ID + '><input type="hidden" id="hdnId"  value=' + data[i].ID + '>';
                row += '</div>';
                row += '<div class="desc" style="color:' + data[i].BagColour + '" >' + data[i].BagName + '</div>';
                row += '<a>';


                row += '<img src=' + data[i].Image + ' alt="mountains" width="600" height="auto">';
              

                row += '</a>';
                row += '</div>';


            }
            $('#divimageBind').append(row);
        }
        function ValidateData() {
            debugger;
            var DepartMent = $('[id$=ddlDepartment]').val();

            $("#hdndepartmentId").val(DepartMent);
            if (DepartMent == '0') {
                modelAlert('Please Select Department', function () {
                    $('#ddlDepartment').focus();
                });
                return false;
            }
            BagType = [];
            var validate = 0;
            $('#divimageBind input[type=checkbox]').filter(function () {
                var row = $(this);

                if (($(this).is(":checked"))) {

                    BagType.push({
                        BagId: $(this).val(),
                    });
                }
            });


            if (BagType.length <= 0) {
                modelAlert('Please Select Any Bag..');
                return false;
            }
            var data = {
                DepartMent: $('[id$=ddlDepartment]').val(),
                BagType: BagType,



            }
            serverCall('Services/BioMedicalwaste.asmx/SaveBagidWithDepartment', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    location.reload(true);
                });
            });
        }
        function Getdata(DepartmentId) {
            serverCall('Services/BioMedicalwaste.asmx/GetDataDepartmentWise', { DepartmentId: DepartmentId }, function (response) {
                debugger;

                var responseData = JSON.parse(response);
                BindImage(responseData);

            });
        }

        var Clear = function () {
            location.reload(true);

        }
    </script>

    <style type="text/css">
        div.gallery {
            margin: 5px;
            border: 1px solid #ccc;
            float: left;
            width: 180px;
            height: auto;
        }

            div.gallery:hover {
                border: 1px solid #777;
            }

            div.gallery img {
                width: 100%;
                height: 132px;
            }

        div.desc {
            padding: 5px;
            text-align: center;
            font-weight: 700;
            font-size: 18px;
        }

        input.largerCheckbox {
            width: 20px;
            height: 26px;
        }
    </style>

    <div id="Pbody_box_inventory">
        <input type="hidden" id="hdndepartmentId" name="user" value="texens" />
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Map Bio Medical With Department</b>
            <span style="display: none" id="spnBagID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">

                        <div class="col-md-4">
                            <label class="pull-left">Select Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" onchange="Getdata(this.value,function(){});" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                        </div>

                    </div>
                    <div class="row" id="divimageBind">
                        <%-- <div class="gallery">
                            <a target="_blank" href="img_mountains.jpg">
                                 <img src="img_mountains.jpg" alt="mountains" width="600" height="400">
                            </a>
                            <div class="desc">add a description of the image here</div>
                        </div>--%>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnsave" value="Save" onclick="return ValidateData();" />

                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>

    </div>
</asp:Content>

